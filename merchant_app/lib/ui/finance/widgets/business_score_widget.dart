// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/finance/widgets/score_view.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class BusinessScoreWidget extends StatefulWidget {
  final BusinessPerformanceScore? score;

  final bool displayFooter;

  final bool displayHeader;

  const BusinessScoreWidget({
    Key? key,
    required this.score,
    this.displayFooter = true,
    this.displayHeader = false,
  }) : super(key: key);

  @override
  State<BusinessScoreWidget> createState() => _BusinessScoreWidgetState();
}

class _BusinessScoreWidgetState extends State<BusinessScoreWidget> {
  int? _selectedIndex;
  PageController? _controller;

  @override
  void initState() {
    _selectedIndex = 0;
    _controller = PageController(initialPage: _selectedIndex!);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topLineRadius = MediaQuery.of(context).size.width / 12;
    return Column(
      children: <Widget>[
        Visibility(
          visible: widget.displayHeader,
          child: scoreHeader(context, widget.score),
        ),
        Visibility(visible: widget.displayHeader, child: const CommonDivider()),
        SizedBox(
          height: 104,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              topLineItem(
                firstValue: widget.score!.sales!.score,
                secondValue: widget.score!.sales!.max,
                title: 'Sales',
                index: 0,
                radius: topLineRadius,
              ),
              topLineItem(
                firstValue: widget.score!.growth!.score,
                secondValue: widget.score!.growth!.max,
                title: 'Growth',
                index: 1,
                radius: topLineRadius,
              ),
              topLineItem(
                firstValue: widget.score!.systemUse!.score,
                secondValue: widget.score!.systemUse!.max,
                title: 'Usage',
                index: 2,
                radius: topLineRadius,
              ),
              topLineItem(
                firstValue: widget.score!.penalties!.score,
                secondValue: widget.score!.penalties!.max,
                title: 'Penalties',
                index: 3,
                radius: topLineRadius,
              ),
            ],
          ),
        ),
        const CommonDivider(),
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              _selectedIndex = index;
              if (mounted) setState(() {});
            },
            physics: const BouncingScrollPhysics(),
            children: [
              scoreItemList(widget.score!.sales!.items, context),
              scoreItemList(widget.score!.growth!.items, context),
              scoreItemList(widget.score!.systemUse!.items, context),
              scoreItemList(widget.score!.penalties!.items, context),
            ],
          ),
        ),
        const CommonDivider(),
        Visibility(
          visible: widget.displayFooter,
          child: SizedBox(
            height: 54,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                valueTile(
                  value: widget.score!.sales!.score!.round().toString(),
                  description: 'Sales',
                ),
                valueTile(value: '+'),
                valueTile(
                  value: widget.score!.growth!.score!.round().toString(),
                  description: 'Growth',
                ),
                valueTile(value: '+'),
                valueTile(
                  value: widget.score!.systemUse!.score!.round().toString(),
                  description: 'Usage',
                ),
                valueTile(value: '-'),
                valueTile(
                  value: widget.score!.penalties!.score!.round().toString(),
                  description: 'Penalties',
                ),
                valueTile(value: '='),
                valueTile(value: widget.score!.finalScore!.round().toString()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget topLineItem({
    double? firstValue,
    double? secondValue,
    int? index,
    String? title,
    double radius = 16,
    double height = 200,
  }) => InkWell(
    onTap: () {
      if (mounted) {
        setState(() {
          _controller?.animateToPage(
            index!,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
          );
        });
      }
    },
    child: Container(
      width: radius * 2.5,
      height: height,
      color: _selectedIndex == index ? Colors.grey.shade200 : Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ScoreView(
            firstValue: firstValue,
            secondValue: secondValue,
            fontSize: 14,
            lineWidth: 6,
            radius: radius,
            color: firstValue == secondValue
                ? Theme.of(context).colorScheme.primary
                : widget.score!.getColor(firstValue, secondValue),
            backgroundColor: _selectedIndex == index ? Colors.white : null,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: LongText(
              title,
              fontSize: 12,
              alignment: TextAlign.center,
              textColor: _selectedIndex == index
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.black87,
              fontWeight: _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );

  Widget scoreTile(Score score, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(score.description!),
                score.showRecommendation!
                    ? LongText(score.recommendation, maxLines: 5)
                    : const LongText('Looking good'),
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: ScoreView(
                  color: score.showRecommendation!
                      ? widget.score!.getColor(score.value, score.max)
                      : Theme.of(context).colorScheme.primary,
                  firstValue: score.value,
                  secondValue: score.max,
                  fontSize: 12,
                  lineWidth: 6,
                  radius: MediaQuery.of(context).size.width / 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget valueTile({required String value, String description = ''}) {
    if ('+-='.contains(value)) {
      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 10,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      );
    }
  }

  ListView scoreItemList(List<Score>? items, BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: items?.length ?? 0,
      itemBuilder: (ctx, index) => scoreTile(items![index], ctx),
      separatorBuilder: (ctx, index) => const CommonDivider(),
    );
  }

  Widget scoreHeader(context, BusinessPerformanceScore? score) => Row(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            child: score != null
                ? ScoreView(
                    firstValue: score.finalScore,
                    secondValue: 100,
                    color: score.getColor(score.finalScore, score.max),
                    radius: MediaQuery.of(context).size.width / 8,
                    fontSize: 16,
                  )
                : const Text('No Data'),
          ),
        ),
      ),
      const SizedBox(height: 84, child: VerticalDivider()),
      Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[businessDetails(context)],
      ),
    ],
  );

  Widget businessDetails(context) {
    var store = StoreProvider.of<AppState>(context);

    //important to have the business details loaded from the state only
    var businessState = store.state.businessState;

    var profile = businessState.profile!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${profile.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text('${profile.type!.name}'),
      ],
    );
  }
}
