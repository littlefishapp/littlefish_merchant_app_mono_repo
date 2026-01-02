// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/finance/viewmodels/finance_loanviewmodel.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

// import 'package:provider/provider.dart';

class FinanceLoanCalculator extends StatefulWidget {
  final double? maxLoanAmount;

  final double? minPeriod;

  final double? maxPeriod;

  final Function(double amount)? onAmountChanged;

  final Function(double duration)? onPeriodChanged;

  const FinanceLoanCalculator({
    Key? key,
    required this.maxLoanAmount,
    required this.minPeriod,
    required this.maxPeriod,
    this.onAmountChanged,
    this.onPeriodChanged,
  }) : super(key: key);

  @override
  State<FinanceLoanCalculator> createState() => _FinanceLoanCalculatorState();
}

class _FinanceLoanCalculatorState extends State<FinanceLoanCalculator> {
  LoanViewModel? _model;

  @override
  Widget build(BuildContext context) {
    _model ??= LoanViewModel(
      interestRate: 9,
      loanAmount: 0,
      maximumLoanAmount: widget.maxLoanAmount,
      minimumLoanAmount: 0,
      monthCount: widget.minPeriod!.toInt(),
      minPeriod: widget.minPeriod!.toInt(),
      maxPeriod: widget.maxPeriod!.toInt(),
    );

    return layout(context, _model!);
  }

  dynamic layout(BuildContext context, LoanViewModel model) =>
      calculator(context, model);

  Column calculator(BuildContext context, LoanViewModel vm) => Column(
    children: <Widget>[
      Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              DecoratedText(
                'Loan Amount',
                fontSize: 12.0,
                textColor: Colors.grey.shade700,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(height: 4.0),
              DecoratedText(
                TextFormatter.toStringCurrency(vm.loanAmount, currencyCode: ''),
                fontSize: 24.0,
                textColor: Theme.of(context).colorScheme.secondary,
                alignment: Alignment.bottomCenter,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          const CommonDivider(width: 0.5),
          const SizedBox(height: 4.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LongText(
                      'Min. Payment',
                      fontSize: 10.0,
                      textColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 4.0),
                    DecoratedText(
                      TextFormatter.toStringCurrency(
                        vm.averageRepayment,
                        currencyCode: '',
                      ),
                      fontSize: 20.0,
                      textColor: Theme.of(context).colorScheme.secondary,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24, child: VerticalDivider()),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    LongText(
                      'Over',
                      fontSize: 10.0,
                      textColor: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 4.0),
                    DecoratedText(
                      '${vm.monthCount} Months',
                      fontSize: 20.0,
                      textColor: Theme.of(context).colorScheme.secondary,
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 8.0),
      const CommonDivider(),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LongText(
                  'How much do you want to borrow?',
                  fontSize: null,
                  textColor: Colors.grey.shade700,
                ),
                Slider(
                  onChanged: (value) {
                    setState(() {
                      vm.loanAmount = value;

                      if (widget.onAmountChanged != null) {
                        widget.onAmountChanged!(value);
                      }
                    });
                  },
                  label: TextFormatter.toStringCurrency(
                    vm.loanAmount,
                    currencyCode: '',
                  ),
                  value: vm.loanAmount!,
                  divisions: 40,
                  max: _model!.maximumLoanAmount!,
                  min: 0,
                  onChangeEnd: (value) {
                    vm.loanAmount = value;
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LongText(
                  'For how long? ${vm.monthCount!.round()} months',
                  fontSize: null,
                  textColor: Colors.grey.shade700,
                ),
                Slider(
                  onChanged: (value) {
                    if (widget.onPeriodChanged != null) {
                      widget.onPeriodChanged!(value);
                    }

                    setState(() {
                      vm.monthCount = value.round();
                    });
                  },
                  label: '${vm.monthCount!.round()} months',
                  value: (vm.monthCount ?? 1).toDouble(),
                  divisions: _model!.maxPeriod,
                  max: _model!.maxPeriod!.toDouble(),
                  min: _model!.minPeriod!.toDouble(),
                  onChangeEnd: (value) {
                    vm.monthCount = value.round();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
