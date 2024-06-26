// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:stockdb/constants/uithemes.dart';
const double _kDefaultIndicatorRadius = 10.0;

/// An activity indicator.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/progress-indicators/#activity-indicators>
class ActivityIndicatorWidget extends StatefulWidget {
  /// Creates an iOS-style activity indicator.
  const ActivityIndicatorWidget({
    Key key,
    this.animating = true,
    this.firstColor,
    this.secondColor,
    this.radius = _kDefaultIndicatorRadius,
  }) : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  final Color firstColor;
  final Color secondColor;

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  @override
  _ActivityIndicatorWidgetState createState() => _ActivityIndicatorWidgetState();
}


class _ActivityIndicatorWidgetState extends State<ActivityIndicatorWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating)
      _controller.repeat();
  }

  @override
  void didUpdateWidget(ActivityIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating)
        _controller.repeat();
      else
        _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          firstColor: widget.firstColor ?? UIThemes.backgroundColor,
          secondColor: widget.secondColor ?? UIThemes.primaryColor,
          position: _controller,
          radius: widget.radius,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;
const int _kHalfTickCount = _kTickCount ~/ 2;

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    this.firstColor,
    this.secondColor,
    this.position,
    double radius,
  }) : tickFundamentalRRect = RRect.fromLTRBXY(
    -radius,
    1.0 * radius / _kDefaultIndicatorRadius,
    -radius / 2.0,
    -1.0 * radius / _kDefaultIndicatorRadius,
    1.0,
    1.0,
  ),
        super(repaint: position);

  final Color firstColor;
  final Color secondColor;
  final Animation<double> position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_kTickCount * position.value).floor();

    for (int i = 0; i < _kTickCount; ++ i) {
      final double t = (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(firstColor, secondColor, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
