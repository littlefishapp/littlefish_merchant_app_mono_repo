import 'package:flutter/material.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/use_case/loading.dart';

class LoadingPage extends StatefulWidget {
  static const route = '/loading';
  final bool? enableLogon;
  final String? displayMessage;
  final void Function()? onLogonCallback;

  const LoadingPage({
    Key? key,
    this.displayMessage,
    this.enableLogon = true,
    this.onLogonCallback,
  }) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    if (widget.enableLogon == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLogonCallback?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loadingWithMessage(
      widget.displayMessage ?? 'Loading, this may take a few seconds...',
    );
  }
}
