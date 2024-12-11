import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatefulWidget {
  const IntroPage3({super.key});

  @override
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(00, 60),
      child: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(100, -50),
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.black,
                  child: LottieBuilder.asset('assets/Animations/share.json'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: const [
                                Colors.purple,
                                Colors.cyan,
                                Color.fromARGB(
                                    66, 49, 67, 183), // Replace with deep blue
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              transform: GradientRotation(
                                  _controller.value * 2.0 * 3.141592653589793),
                            ).createShader(bounds);
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: const Text(
                              'Download & Share',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // Text color acts as a mask
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding:
                          EdgeInsets.only(left: 20.0), // Add space from left
                      child: Text(
                        'Download your favourite generated images and share it with your friends.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 50), // Push further away from the button
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
