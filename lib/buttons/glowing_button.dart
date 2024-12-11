import 'dart:math';

import 'package:flutter/material.dart';

class GlowingButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const GlowingButton({super.key, required this.onPressed, required this.text});

  @override
  State<GlowingButton> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton>
    with SingleTickerProviderStateMixin {
  bool ishover = false;
  final Color color1 = Colors.purple;
  final Color color2 = Colors.cyan;

  double size = 70.00;
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..forward()
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return InkWell(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            onHover: (value) {
              ishover = value;
            },
            onTapDown: (details) {
              size = 60.00;
            },
            onTapUp: (details) {
              size = 70.00;
            },
            onTap: widget.onPressed,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: ishover
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  gradient: LinearGradient(
                      colors: [color1, color2],
                      transform: GradientRotation(controller.value * 2 * pi)),
                  boxShadow: [
                    BoxShadow(
                        color: color2,
                        blurRadius: 10,
                        spreadRadius: 1.5,
                        offset: Offset.fromDirection(
                            controller.value * 2 * pi, 3.5)),
                    BoxShadow(
                        color: color1,
                        blurRadius: 10,
                        spreadRadius: 1.5,
                        offset: Offset.fromDirection(
                            (controller.value + 0.5) * 2 * pi, 3.5)),
                  ]),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: ishover
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.5),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
