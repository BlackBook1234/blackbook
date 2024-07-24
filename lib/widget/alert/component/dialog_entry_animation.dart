import 'package:flutter/material.dart';
import 'utils.dart';

// Доороос дээшээ гарч ирдэг animation.
class DialogEntryAnimation extends StatelessWidget {
  const DialogEntryAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      builder: (ctx, animation, _) => FractionalTranslation(
        translation: Offset(0.0, lerp(1.0, 0.0, animation)),
        child: Transform.scale(
          scale: lerp(1.0, 1.0, animation),
          child: child,
        ),
      ),
    );
  }
}
