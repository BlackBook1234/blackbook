import 'dart:async';
import 'package:black_book/models/banner/detial.dart';
import 'package:black_book/screen/home/widget/banners_carousel.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HeadphoneBanner extends StatefulWidget {
  const HeadphoneBanner({Key? key, required this.urls}) : super(key: key);
  final List<BannerDetial> urls;

  @override
  State<HeadphoneBanner> createState() => _HeadphoneBannerState();
}

class _HeadphoneBannerState extends State<HeadphoneBanner> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  // int currentIndex = 0;

  final ScrollController controller = ScrollController(initialScrollOffset: 0);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_currentPage < widget.urls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 120,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.urls.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          widget.urls[index].url!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: widget.urls.length > 1
                    ? Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(left: 5),
                          controller: controller,
                          scrollDirection: Axis.horizontal,
                          child: AnimatedSmoothIndicator(
                            count: widget.urls.length,
                            activeIndex: _currentPage,
                            axisDirection: Axis.horizontal,
                            effect: CustomizableEffect(
                              activeDotDecoration: DotDecoration(
                                width: 12,
                                height: 8,
                                color: fromHex('#EFEFF0'),
                                rotationAngle: 180,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              dotDecoration: DotDecoration(
                                width: 8,
                                height: 8,
                                color: fromHex('#b3b3b3'),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              spacing: 8.0,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Make sure you have this helper function defined somewhere in your code
  // Color fromHex(String hexString) {
  //   final buffer = StringBuffer();
  //   if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  //   buffer.write(hexString.replaceFirst('#', ''));
  //   return Color(int.parse(buffer.toString(), radix: 16));
  // }
}
