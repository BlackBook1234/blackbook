import 'dart:async';
import 'package:black_book/constant.dart';
import 'package:black_book/models/banner/detial.dart';
import 'package:flutter/material.dart';

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
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.urls.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? kPrimaryColor : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
