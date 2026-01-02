import 'package:flutter/material.dart';

class ListDetailView extends StatefulWidget {
  final Widget listWidget;
  final Widget detailWidget;
  const ListDetailView({
    super.key,
    required this.listWidget,
    required this.detailWidget,
  });

  @override
  State<ListDetailView> createState() => _ListDetailViewState();
}

class _ListDetailViewState extends State<ListDetailView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: widget.listWidget),
        const VerticalDivider(width: 0.5),
        Expanded(flex: 3, child: widget.detailWidget),
      ],
    );
  }
}
