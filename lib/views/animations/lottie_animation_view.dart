import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_taking_app/views/animations/models/lottie_animation.dart';

class LottieAnimationView extends StatefulWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;
  final int? animationPause;
  final int? animationDuration;

  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
    this.animationPause,
    this.animationDuration,
  });

  @override
  LottieAnimationViewState createState() => LottieAnimationViewState();
}

class LottieAnimationViewState extends State<LottieAnimationView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  void _playAnimation() {
    _timer = Timer.periodic(
      Duration(seconds: widget.animationPause ?? 3),
      (timer) {
        _controller.forward(from: 0);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // Pass the TickerProvider here
      duration: Duration(milliseconds: widget.animationDuration ?? 800),
    );
    _playAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.animation.fullPath,
      reverse: widget.reverse,
      controller: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer when disposing of the widget
    super.dispose();
  }
}
