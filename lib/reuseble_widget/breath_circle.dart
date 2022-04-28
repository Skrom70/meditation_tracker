import 'dart:math';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BreathCircle extends StatelessWidget {
  const BreathCircle(
      {Key? key,
      required this.initalValue,
      required this.maxValue,
      required this.size})
      : super(key: key);

  final int initalValue;
  final int maxValue;
  final int size;

  @override
  Widget build(BuildContext context) {
    final radius = (size / 2);
    final double maxArea = pi * radius * radius;
    final k = initalValue / maxValue;
    final double initalArea = maxArea * k;
    final double initalSize = sqrt(initalArea / pi) * 2;

    if (k == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(initalSize / 2)),
        child: Container(
          width: initalSize,
          height: initalSize,
          color: Theme.of(context).primaryColor.withOpacity(k),
        ),
      );
    } else {
      return DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(size / 2),
        color: Theme.of(context).primaryColor,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          child: Container(
            height: size.toDouble(),
            width: size.toDouble(),
            child: Center(
                child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(initalSize / 2)),
              child: Container(
                width: initalSize,
                height: initalSize,
                color: Theme.of(context).primaryColor,
              ),
            )),
          ),
        ),
      );
    }
  }
}
