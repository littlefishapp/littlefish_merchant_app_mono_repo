// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/finance/viewmodels/finance_vm.dart';
import 'package:littlefish_merchant/ui/finance/widgets/business_score_widget.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

class FinanceScoreBreakdownPage extends StatefulWidget {
  final FinanceVM? vm;

  const FinanceScoreBreakdownPage({Key? key, required this.vm})
    : super(key: key);

  @override
  State<FinanceScoreBreakdownPage> createState() =>
      _FinanceScoreBreakdownPageState();
}

class _FinanceScoreBreakdownPageState extends State<FinanceScoreBreakdownPage> {
  late int _selectedIndex;
  PageController? _controller;

  @override
  void initState() {
    _selectedIndex = 0;
    _controller = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _layout(context);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  AppSimpleAppScaffold _layout(context) => AppSimpleAppScaffold(
    isEmbedded: true,
    title: 'Score Breakdown',
    body: BusinessScoreWidget(score: widget.vm!.performanceScore),
  );
}
