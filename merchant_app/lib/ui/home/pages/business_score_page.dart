// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/finance_api/score_service.dart';
import 'package:littlefish_merchant/ui/finance/widgets/business_score_widget.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class BusinessScorePage extends StatefulWidget {
  const BusinessScorePage({Key? key}) : super(key: key);

  @override
  State<BusinessScorePage> createState() => _BusinessScorePageState();
}

class _BusinessScorePageState extends State<BusinessScorePage> {
  Future<BusinessPerformanceScore?>? _future;

  ScoreService? _service;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ScoreService?>(
      converter: (store) {
        if (_service == null) {
          _service = ScoreService.fromStore(store);

          _future = _service!.getBusinessPerfomanceScore();
        }
        return _service;
      },
      builder: (ctx, service) => FutureBuilder<BusinessPerformanceScore?>(
        future: _future,
        builder: (c, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TextTag(
                displayText: 'Something Went Wrong',
                color: Theme.of(context).colorScheme.error,
              ),
            );
          }

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return layout(ctx, snapshot.data);

            default:
              return const AppProgressIndicator();
          }
        },
      ),
    );
  }

  Widget layout(context, BusinessPerformanceScore? score) => score == null
      ? const Center(child: TextTag(displayText: 'No Data'))
      : BusinessScoreWidget(
          score: score,
          displayFooter: false,
          displayHeader: true,
        );
}
