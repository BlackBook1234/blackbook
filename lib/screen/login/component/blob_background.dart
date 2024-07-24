import 'package:flutter/material.dart';

import 'blob.dart';
import 'models.dart';

class BlobBackground extends StatefulWidget {
  const BlobBackground({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<BlobBackground> createState() => _BlobBackgroundState();
}

class _BlobBackgroundState extends State<BlobBackground> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Blob.animatedFromID(
            loop: true,
            id: const [
              '17-8-473',
              '17-8-350',
              '17-8-200',
              '17-8-179',
            ],
            size: 800.0,
            duration: const Duration(milliseconds: 5000),
            styles: BlobStyles(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff8780BF).withOpacity(0),
                  const Color(0xff8780BF).withOpacity(0),
                  const Color(0xffAEAAD0).withOpacity(0.2)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ).createShader(
                Rect.fromCenter(
                  center: const Offset(800 / 2, 800 / 2),
                  width: 800,
                  height: 800,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Blob.animatedFromID(
            loop: true,
            id: const [
              '17-8-1233',
              '17-8-3312',
              '17-8-2320',
              '17-8-179',
            ],
            size: 600.0,
            duration: const Duration(milliseconds: 5000),
            styles: BlobStyles(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff8780BF).withOpacity(0),
                  const Color(0xff8780BF).withOpacity(0),
                  const Color(0xffAEAAD0).withOpacity(0.2)
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ).createShader(
                Rect.fromCenter(
                  center: const Offset(800 / 2, 800 / 2),
                  width: 800,
                  height: 800,
                ),
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
