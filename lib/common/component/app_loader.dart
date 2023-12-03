import 'dart:math' as math;
import 'dart:math';

import 'package:example/common/common_controller.dart';
import 'package:example/common/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class DelayTween extends Tween<double> {
  DelayTween({
    double? begin,
    double? end,
    required this.delay,
  }) : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

class SpinKitSpinningLines extends StatefulWidget {
  const SpinKitSpinningLines({
    Key? key,
    required this.color,
    this.size = 70,
    this.lineWidth = 2.0,
    this.itemCount = 5,
    this.duration = const Duration(milliseconds: 3000),
    this.controller,
  }) : super(key: key);

  final Color color;
  final double size;

  final double lineWidth;
  final int itemCount;

  final Duration duration;
  final AnimationController? controller;

  @override
  State<SpinKitSpinningLines> createState() => _SpinKitSpinningLinesState();
}

class _SpinKitSpinningLinesState extends State<SpinKitSpinningLines> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat();

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: SpinningLinesPainter(
              _animation.value,
              lineWidth: widget.lineWidth,
              color: widget.color,
              itemCount: widget.itemCount,
            ),
            child: SizedBox.fromSize(size: Size.square(widget.size)),
          );
        },
        animation: _animation,
      ),
    );
  }
}

class SpinningLinesPainter extends CustomPainter {
  SpinningLinesPainter(
    this.rotateValue, {
    required Color color,
    required this.lineWidth,
    required this.itemCount,
  }) : _linePaint = Paint()
          ..color = color
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  final double rotateValue;
  final double lineWidth;
  final int itemCount;

  final Paint _linePaint;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 1; i <= itemCount; i++) {
      _drawSpin(canvas, size, _linePaint, i);
    }
  }

  void _drawSpin(Canvas canvas, Size size, Paint paint, int scale) {
    final scaledSize = size * (scale / itemCount);
    final spinnerSize = Size.square(scaledSize.longestSide);

    final startX = spinnerSize.width / 2;
    final startY = spinnerSize.topCenter(Offset.zero).dy;

    final radius = spinnerSize.width / 4;

    final endX = startX;
    final endY = spinnerSize.bottomCenter(Offset.zero).dy;

    final borderWith = lineWidth;

    final scaleFactor = -(scale - (itemCount + 1));

    final path = Path();
    path.moveTo(startX, startY);
    path.arcToPoint(
      Offset(endX, endY),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.arcToPoint(
      Offset(startX, startY + borderWith),
      radius: Radius.circular(radius),
    );
    path.lineTo(startX, startY);

    canvas.save();
    _translateCanvas(canvas, size, spinnerSize);
    _rotateCanvas(
      canvas,
      spinnerSize,
      _getRadian(rotateValue * 360 * scaleFactor),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _translateCanvas(Canvas canvas, Size size, Size spinnerSize) {
    final offset = (size - spinnerSize as Offset) / 2;
    canvas.translate(offset.dx, offset.dy);
  }

  /// I use the following resource to calculate rotation of the canvas
  /// https://stackoverflow.com/a/54336099/9689717
  void _rotateCanvas(Canvas canvas, Size size, double angle) {
    final double r = sqrt(size.width * size.width + size.height * size.height) / 2;
    final alpha = atan(size.height / size.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = size.width / 2 - shiftX;
    final translateY = size.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
  }

  double _getRadian(double angle) => math.pi / 180 * angle;

  @override
  bool shouldRepaint(SpinningLinesPainter oldDelegate) {
    return oldDelegate.rotateValue != rotateValue || oldDelegate.lineWidth != lineWidth || oldDelegate.itemCount != itemCount || oldDelegate._linePaint != _linePaint;
  }
}

class AppLoader extends StatelessWidget {
  final Color? backgroundColor;

  const AppLoader({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Selector<CommonController, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, value, child) {
        if (value) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitSpinningLines(color: backgroundColor ?? context.primaryColor, lineWidth: 8, size: PilluThemeData.globalActiveButtonHeight * 1.2),
              8.height,
              Text("Loading ..", style: boldTextStyle(size: 12, color: backgroundColor ?? context.primaryColor)),
            ],
          );
        } else {
          return Offstage();
        }
      },
    ).center(heightFactor: 5.8);
  }
}
