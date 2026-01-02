// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

@immutable
class NybbleStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const NybbleStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive = false,
  });

  /// The title of the step that typically describes it.
  final String title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final String? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;
}

const TextStyle _kStepStyle = TextStyle(fontSize: 12.0, color: Colors.white);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

class NybbleStepper extends StatefulWidget {
  const NybbleStepper({
    Key? key,
    required this.steps,
    this.physics,
    this.type = StepperType.vertical,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.showStepCounter = true,
    this.controlsBuilder,
  }) : assert(0 <= currentStep && currentStep < steps.length),
       super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<NybbleStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final StepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepCancel;

  final ControlsWidgetBuilder? controlsBuilder;

  // Whether the stepper should show the current step
  final bool showStepCounter;

  @override
  State<NybbleStepper> createState() => _NybbleStepperState();
}

class _NybbleStepperState extends State<NybbleStepper>
    with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(NybbleStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.steps.length == oldWidget.steps.length) {
      for (int i = 0; i < oldWidget.steps.length; i += 1) {
        _oldStates[i] = oldWidget.steps[i].state;
      }
    } else {
      initState();
    }
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget? _buildCircleChild(int index, bool oldState) {
    final StepState state = oldState
        ? _oldStates[index]!
        : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    switch (state) {
      case StepState.indexed:
      case StepState.disabled:
        return Icon(
          MdiIcons.minus,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    return SizedBox(
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        child: Center(
          child: Container(
            height: widget.steps[index].state == StepState.editing ? 4 : 2,
            color: widget.steps[index].state == StepState.editing
                ? Theme.of(context).colorScheme.secondary
                : widget.steps[index].state == StepState.complete
                ? Colors.green
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height:
              _kTriangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(
                0.0,
                0.8,
              ), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(
                index,
                oldState && widget.steps[index].state != StepState.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != StepState.error) {
      return _buildCircle(index, false);
    } else {
      return _buildTriangle(index, false);
    }
  }

  Widget _buildVerticalControls() {
    var controlsDetails = ControlsDetails(
      currentStep: widget.currentStep,
      stepIndex: widget.currentStep,
      onStepContinue: widget.onStepContinue,
      onStepCancel: widget.onStepCancel,
    );
    if (widget.controlsBuilder != null) {
      return widget.controlsBuilder!(context, controlsDetails);
    }

    switch (Theme.of(context).brightness) {
      case Brightness.light:
        break;
      case Brightness.dark:
        break;
    }

    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          children: <Widget>[
            ButtonText(
              onTap: (_) {
                widget.onStepContinue;
              },
              text: localizations.continueButtonLabel,
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: ButtonText(
                onTap: (_) {
                  widget.onStepCancel;
                },
                text: localizations.cancelButtonLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TODO(lampian): not referenced
  // TextStyle? _titleStyle(int index) {
  //   final ThemeData themeData = Theme.of(context);
  //   final TextTheme textTheme = themeData.textTheme;

  //   switch (widget.steps[index].state) {
  //     case StepState.indexed:
  //     case StepState.editing:
  //     case StepState.complete:
  //       return textTheme.bodyText1;
  //     case StepState.disabled:
  //       return textTheme.bodyText1!
  //           .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
  //     case StepState.error:
  //       return textTheme.bodyText1!
  //           .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
  //   }
  // }

  TextStyle? _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        return textTheme.bodySmall;
      case StepState.disabled:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // AnimatedDefaultTextStyle(
        //   style: _titleStyle(index),
        //   duration: kThemeAnimationDuration,
        //   curve: Curves.fastOutSlowIn,
        //   child: Text(
        //     widget.steps[index].title,
        //     style: TextStyle(fontSize: 24),
        //   ),
        // ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index)!,
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: Text(widget.steps[index].subtitle!),
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              // _buildLine(!_isFirst(index)),
              _buildIcon(index),
              // _buildLine(!_isLast(index)),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 12.0),
            child: _buildHeaderText(index),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(color: Colors.grey.shade400),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0,
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.steps[i].state != StepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext!,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        if (widget.onStepTapped != null) {
                          widget.onStepTapped!(i);
                        }
                      }
                    : null,
                canRequestFocus: widget.steps[i].state != StepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != StepState.disabled
              ? () {
                  if (widget.onStepTapped != null) widget.onStepTapped!(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 52, child: _buildIcon(i)),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(8),
            //   topRight: Radius.circular(8),
            // ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(widget.steps[widget.currentStep].title),
                  ),
                  // SizedBox(height: 4),
                  if (widget.steps[widget.currentStep].subtitle != null)
                    context.paragraphSmall(
                      widget.steps[widget.currentStep].subtitle!,
                    ),
                  const SizedBox(height: 4),
                  if (widget.showStepCounter) const SizedBox(height: 12),
                  if (widget.showStepCounter)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        context.paragraphSmall(
                          'Step ${widget.currentStep + 1} / ${widget.steps.length}',
                        ),
                        // SizedBox(width: 12),
                      ],
                    ),
                  Row(children: children),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
          Expanded(
            child: Material(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(8),
                  //   topRight: Radius.circular(8),
                  // ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    AnimatedSize(
                      curve: Curves.fastOutSlowIn,
                      duration: kThemeAnimationDuration,
                      //vsync: this,
                      child: widget.steps[widget.currentStep].content,
                    ),
                    _buildVerticalControls(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());
    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
    // return null;
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({this.color});

  final Color? color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(Path()..addPolygon(points, true), Paint()..color = color!);
  }
}
