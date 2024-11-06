import 'package:flutter/material.dart';

import 'models.dart';
import 'tools.dart';

class SimpleBlob extends StatelessWidget {
  final double? size;
  final BlobData blobData;
  final bool debug;
  final Widget? child;
  final BlobStyles? styles;

  const SimpleBlob({super.key, 
    required this.blobData,
    this.size,
    this.debug = false,
    this.styles,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: RepaintBoundary(
        child: CustomPaint(
          painter: BlobPainter(
            blobData: blobData,
            debug: debug,
            styles: styles,
          ),
          child: child,
        ),
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  final BlobData blobData;
  final bool debug;
  final BlobStyles? styles;

  BlobPainter({
    required this.blobData,
    this.styles,
    this.debug = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawBlob(canvas, blobData.path!, styles);
    if (debug) {
      circle(canvas, size, (size.width / 2)); // outer circle
      circle(canvas, size, blobData.points!.innerRad!); // inner circle
      point(canvas, Offset(size.width / 2, size.height / 2)); // center point
      List originPoints = blobData.points!.originPoints!;
      List? destPoints = blobData.points!.destPoints;
      originPoints.asMap().forEach(
            (i, p) => drawLines(canvas, p, destPoints![i]),
          ); // line from  inner  circle to blob point
    }
  }

  drawLines(Canvas c, Offset p0, Offset p1) {
    point(c, p0);
    point(c, p1);
    line(c, p0, p1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

