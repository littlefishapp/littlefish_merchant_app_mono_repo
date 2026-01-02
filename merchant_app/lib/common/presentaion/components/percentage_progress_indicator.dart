// flutter imports
import 'package:flutter/material.dart';

class PercentageProgressIndicator extends StatefulWidget {
  final double percentage;
  final bool showPercentageText;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final bool animated;

  const PercentageProgressIndicator({
    Key? key,
    required this.percentage,
    this.showPercentageText = true,
    this.padding = const EdgeInsets.all(0),
    this.color,
    this.animated = true,
  }) : super(key: key);

  @override
  State<PercentageProgressIndicator> createState() =>
      _PercentageProgressIndicatorState();
}

class _PercentageProgressIndicatorState
    extends State<PercentageProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 0, end: widget.percentage).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    if (widget.animated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant PercentageProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation =
          Tween<double>(begin: 0, end: widget.percentage).animate(_controller)
            ..addListener(() {
              setState(() {});
            });
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color progressBarColor =
        widget.color ?? Theme.of(context).colorScheme.secondary;

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: widget.animated
                  ? _animation.value / 100
                  : widget.percentage / 100,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(progressBarColor),
              minHeight: 10,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          if (widget.showPercentageText)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              // TODO(lampian): convert to theme
              child: Text(
                widget.animated
                    ? '${(_animation.value).toStringAsFixed(0)}%'
                    : '${(widget.percentage).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: progressBarColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
