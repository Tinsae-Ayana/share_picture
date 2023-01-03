import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimationg;
  final Duration? duration;
  final VoidCallback? onEnd;
  final bool smallLike;

  const LikeAnimationWidget(
      {super.key,
      required this.child,
      required this.isAnimationg,
      this.duration = const Duration(microseconds: 150),
      this.onEnd,
      this.smallLike = false});

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> scale;
  double _currentOpacity = 0;

  startAnimation() async {
    await _animationController.forward();
    await _animationController.reverse();
    await Future.delayed(const Duration(milliseconds: 200));

    // if (widget.onEnd != null) {
    //   widget.onEnd!();
    // }
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    scale = Tween<double>(begin: 1, end: 2.1).animate(_animationController);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    if (oldWidget.isAnimationg != widget.isAnimationg) {
      if (widget.smallLike) {
        startAnimation();
      } else {
        setState(() {
          _currentOpacity = 1;
        });
        Future.delayed(const Duration(milliseconds: 500)).then((value) {
          setState(() {
            _currentOpacity = 0;
          });
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.smallLike) {
      return ScaleTransition(scale: scale, child: widget.child);
    } else {
      return AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: _currentOpacity,
          child: widget.child);
    }
  }
}
