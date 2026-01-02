// flutter imports
import 'package:flutter/material.dart';

class KeyboardDismissalUtility extends StatefulWidget {
  final Widget content;
  final BuildContext? parentContext;
  final Function(BuildContext)? onCloseKeyboard;

  const KeyboardDismissalUtility({
    Key? key,
    required this.content,
    this.parentContext,
    this.onCloseKeyboard,
  }) : super(key: key);

  @override
  State<KeyboardDismissalUtility> createState() =>
      _KeyboardDismissalUtilityState();
}

class _KeyboardDismissalUtilityState extends State<KeyboardDismissalUtility> {
  late FocusNode _focusNode;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus && !_keyboardVisible) {
      setState(() {
        _keyboardVisible = true;
      });
    } else if (!_focusNode.hasFocus && _keyboardVisible) {
      _onKeyboardClose();
    }
  }

  void _onKeyboardClose() {
    if (_keyboardVisible) {
      setState(() {
        _keyboardVisible = false;
      });
      if (widget.onCloseKeyboard != null) {
        widget.onCloseKeyboard!(widget.parentContext ?? context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus all focus nodes
        FocusScope.of(context).unfocus();
        _onKeyboardClose();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: Focus(focusNode: _focusNode, child: widget.content),
      ),
    );
  }
}
