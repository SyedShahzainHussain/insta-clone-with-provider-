import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class likeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimaton;
  final Duration? duration;
  final VoidCallback? onEnd;
  final bool? isSmallLIke;

  const likeAnimation(
      {super.key,
      required this.child,
      required this.isAnimaton,
      this.duration = const Duration(milliseconds: 150),
      this.onEnd,
      this.isSmallLIke = false});

  @override
  State<likeAnimation> createState() => _likeAnimationState();
}

class _likeAnimationState extends State<likeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration!.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void didUpdateWidget(covariant likeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimaton != oldWidget.isAnimaton) {
      print(widget.isAnimaton);
      print(oldWidget.isAnimaton);
      startAniamted();
    }
  }

  void startAniamted() async {
    if (widget.isAnimaton || widget.isSmallLIke!) {
      await _controller.forward();
      await _controller.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
    }
    if (widget.onEnd != null) {
      widget.onEnd!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
