import 'dart:math';

import 'package:flutter/material.dart';

class GlowingButton2 extends StatefulWidget {
  final VoidCallback? onPressed;

  const GlowingButton2({Key? key, this.onPressed}) : super(key: key);

  @override
  State<GlowingButton2> createState() => _GlowingButtonState();
}

class _GlowingButtonState extends State<GlowingButton2>
    with SingleTickerProviderStateMixin {
  bool ishover = false;
  final Color color1 = const Color.fromARGB(255, 255, 0, 85);
  final Color color2 = const Color.fromARGB(255, 44, 159, 167);
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
              ishover = true;
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
                    color: Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                  gradient: ishover
                      ? LinearGradient(
                          colors: [color1, color2],
                          transform:
                              GradientRotation(controller.value * 2 * pi))
                      : null,
                  color: ishover ? null : Colors.grey[900],
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
                  'Next',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
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
