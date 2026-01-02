import 'package:flutter/material.dart';

class InitAppLoading extends StatefulWidget {
  final String message;
  const InitAppLoading({super.key, this.message = 'Loading...'});

  @override
  State<InitAppLoading> createState() => _InitAppLoadingState();
}

class _InitAppLoadingState extends State<InitAppLoading> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '#### InitAppLoading build called with message: ${widget.message}',
    );
    return Center(child: Text(widget.message, textAlign: TextAlign.center));
  }
}
