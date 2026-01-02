// Flutter imports:
import 'package:flutter/material.dart';

class AppBuilder extends StatefulWidget {
  const AppBuilder({Key? key, this.builder}) : super(key: key);
  final Function(BuildContext)? builder;

  @override
  AppBuilderState createState() => AppBuilderState();

  static AppBuilderState? of(BuildContext context) {
    return context.findAncestorStateOfType<AppBuilderState>();

    // return context.ancestorStateOfType(const TypeMatcher<AppBuilderState>());
  }
}

class AppBuilderState extends State<AppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder != null ? widget.builder!(context) : Container();
  }

  void rebuild() {
    setState(() {});
  }
}
