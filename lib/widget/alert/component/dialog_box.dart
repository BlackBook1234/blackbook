// import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  const DialogBox({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 200.0,
              maxHeight: 450.0,
              minWidth: 280.0,
              maxWidth: 280.0,
            ),
            child: Material(
              color: Colors.white,
            
              elevation: 16.0,
              shadowColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
