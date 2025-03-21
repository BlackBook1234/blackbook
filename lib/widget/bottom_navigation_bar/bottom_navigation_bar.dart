import 'package:black_book/constant.dart';
import 'package:black_book/util/utils.dart';
import 'package:flutter/material.dart';

import 'bottom_curved_Painter.dart';

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIconPresedCallback;
  int index;
  CustomBottomNavigationBar(
      {super.key, required this.onIconPresedCallback, required this.index});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  // int widget.index = 0;

  late AnimationController _xController;
  late AnimationController _yController;
  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value =
        _indexToPosition(widget.index) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    var buttonCount = Utils.getUserRole() == "BOSS" ? 5.0 : 4.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(IconData icon, bool isEnable, int index, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            onTap: () {
              _handlePressed(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              alignment: isEnable ? Alignment.topCenter : Alignment.center,
              child: AnimatedContainer(
                width: 40,
                height: isEnable ? 40 : 20,
                duration: const Duration(milliseconds: 300),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: isEnable ? const Color(0xffE65829) : kWhite,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: isEnable ? const Color(0xfffeece2) : kWhite,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(5, 5),
                      ),
                    ],
                    // border: Border.all(width: 1, color: kBackgroundColor),
                    shape: BoxShape.circle),
                child: Opacity(
                  opacity: isEnable ? _yController.value : 1,
                  child: Icon(icon,
                      color: isEnable
                          ? const Color(0XFFFFFFFF)
                          : Theme.of(context).iconTheme.color),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 70,
          child: Center(
            child: Text(
              overflow: TextOverflow.ellipsis,
              name,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    const inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          kWhite),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (widget.index == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      widget.index = index;
    });

    _yController.value = 1.0;
    _xController.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: const Duration(milliseconds: 620));
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0,
            duration: const Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    const height = 60.0;
    return SizedBox(
      width: appSize.width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            // bottom: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: Utils.getUserRole() == "BOSS"
                    ? <Widget>[
                        _icon(Icons.home, widget.index == 0, 0, "Нүүр"),
                        _icon(Icons.favorite, widget.index == 1, 1,
                            "Миний бараа"),
                        _icon(Icons.add_outlined, widget.index == 2, 2,
                            "Бараа нэмэх"),
                        _icon(Icons.shopping_cart, widget.index == 3, 3,
                            "Бараа зарах"),
                        _icon(Icons.search, widget.index == 4, 4, "Хайх"),
                      ]
                    : <Widget>[
                        _icon(Icons.home, widget.index == 0, 0, "Нүүр"),
                        _icon(Icons.favorite, widget.index == 1, 1,
                            "Миний бараа"),
                        _icon(Icons.shopping_cart, widget.index == 3, 3,
                            "Бараа зарах"),
                        _icon(Icons.search, widget.index == 4, 4, "Хайх"),
                      ]),
          ),
        ],
      ),
    );
  }
}
