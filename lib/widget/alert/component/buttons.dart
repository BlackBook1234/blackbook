import 'package:black_book/constant.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import 'touch_scale.dart';

class TouchableOpacity extends StatefulWidget {
  const TouchableOpacity({
    super.key,
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback? onPressed;
  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {
  bool isDown = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) {
        setState(() {
          isDown = true;
        });
      },
      onTapUp: (d) {
        setState(() {
          isDown = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isDown = false;
        });
      },
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1, end: isDown ? 0.5 : 1),
        // curve: Curves.easeOut,
        duration: const Duration(milliseconds: 75),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

class UPointTextButton extends StatelessWidget {
  const UPointTextButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.alignment = Alignment.center,
    this.color = Colors.transparent,
    this.padding = const EdgeInsets.all(8),
    this.height = 32,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final void Function() onPressed;
  final double height;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onPressed: onPressed,
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(color: kPrimaryColor),
          child: Container(
            height: height,
            color: color,
            padding: padding,
            alignment: alignment,
            child: child,
          ),
        ),
      ),
    );
  }
}

class BlackBookButton extends StatelessWidget {
  const BlackBookButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.contentColor,
    this.color = kPrimaryColor,
    this.width,
    this.padding = const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.disabled = false,
    this.shadow = true,
    this.smoothCorner = false,
    this.border,
  }) : super(key: key);
  final Widget child;
  final Color color;
  final double? width;
  final Color? contentColor;
  final bool smoothCorner;
  final void Function() onPressed;
  final double height;
  final EdgeInsets padding;
  final double borderRadius;
  final bool disabled;
  final bool shadow;
  final double? border;

  @override
  Widget build(BuildContext context) {
    final color = disabled ? const Color(0xffF3F3F7) : this.color;
    final brightness = color.computeLuminance();
    final isDark = brightness < 0.6;
    Color contentColor =
        this.contentColor ?? (isDark ? Colors.white : kPrimaryColor);

    if (disabled) contentColor = const Color(0xff9691B5);

    Decoration containerDecoration = smoothCorner
        ? ShapeDecoration(
            color: color,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: borderRadius,
                cornerSmoothing: 0.7,
              ),
              // border: border != null ? Border.all(color: Colors.black, width: border!) : null,
            ),
            shadows: (shadow && (!disabled))
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16.0,
                      offset: const Offset(0, 4.0),
                    ),
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 0.0),
                    ),
                  ]
                : null,
          )
        : BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: (shadow && (!disabled))
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16.0,
                      offset: const Offset(0, 4.0),
                    ),
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 4.0,
                      offset: const Offset(0, 0.0),
                    ),
                  ]
                : null,
          );

    Widget body = AnimatedContainer(
      height: height,
      width: width,
      duration: const Duration(milliseconds: 300),
      decoration: containerDecoration,
      padding: padding,
      child: Align(
        widthFactor: 1.0,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: contentColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          child: IconTheme(
            data: Theme.of(context).iconTheme.copyWith(
                  color: contentColor,
                ),
            child: child,
          ),
        ),
      ),
    );

    if (!disabled) {
      body = TouchableScales(
        onPressed: onPressed,
        child: body,
      );
    }

    return body;
  }
}
