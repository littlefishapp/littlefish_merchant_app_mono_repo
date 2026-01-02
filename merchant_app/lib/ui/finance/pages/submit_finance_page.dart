// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/finance/viewmodels/finance_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class SubmitFinancePage extends StatelessWidget {
  final FinanceVM? vm;
  final String title;
  final bool isEmbedded;
  final BuildContext? parentContext;

  const SubmitFinancePage({
    Key? key,
    required this.vm,
    this.title = 'Loan Summary',
    this.parentContext,
    this.isEmbedded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _layout(context);
  }

  AppSimpleAppScaffold _layout(ctx) => AppSimpleAppScaffold(
    title: title,
    isEmbedded: isEmbedded,
    body: !vm!.isLoading!
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: <Widget>[
                Expanded(
                  // flex: 2,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Column(
                        children: <Widget>[
                          DecoratedText(
                            'Requested By',
                            fontSize: 12.0,
                            textColor: Colors.grey.shade700,
                            alignment: Alignment.topLeft,
                          ),
                          const SizedBox(height: 4.0),
                          DecoratedText(
                            vm!.loanRequest!.userProfile!.displayName,
                            fontSize: 16.0,
                            textColor: Colors.black87,
                            alignment: Alignment.bottomLeft,
                            // fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Column(
                        children: <Widget>[
                          DecoratedText(
                            'Email',
                            fontSize: 12.0,
                            textColor: Colors.grey.shade700,
                            alignment: Alignment.topLeft,
                          ),
                          const SizedBox(height: 4.0),
                          DecoratedText(
                            vm!.loanRequest!.userProfile!.email,
                            fontSize: 16.0,
                            textColor: Colors.black87,
                            alignment: Alignment.bottomLeft,
                            // fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Column(
                        children: <Widget>[
                          DecoratedText(
                            'Identity Number',
                            fontSize: 12.0,
                            textColor: Colors.grey.shade700,
                            alignment: Alignment.topLeft,
                          ),
                          const SizedBox(height: 4.0),
                          DecoratedText(
                            vm!.loanRequest!.requesterIdNumber ?? '',
                            fontSize: 16.0,
                            textColor: Colors.black87,
                            alignment: Alignment.bottomLeft,
                            // fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Column(
                        children: <Widget>[
                          DecoratedText(
                            'Contact Number',
                            fontSize: 12.0,
                            textColor: Colors.grey.shade700,
                            alignment: Alignment.topLeft,
                          ),
                          const SizedBox(height: 4.0),
                          DecoratedText(
                            vm!.loanRequest!.userProfile!.mobileNumber,
                            fontSize: 16.0,
                            textColor: Colors.black87,
                            alignment: Alignment.bottomLeft,
                            // fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Column(
                        children: <Widget>[
                          DecoratedText(
                            'Tax Number',
                            fontSize: 12.0,
                            textColor: Colors.grey.shade700,
                            alignment: Alignment.topLeft,
                          ),
                          const SizedBox(height: 4.0),
                          DecoratedText(
                            vm!.loanRequest!.businessProfile!.taxNumber,
                            fontSize: 16.0,
                            textColor: Colors.black87,
                            alignment: Alignment.bottomLeft,
                            // fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(),
                      const SizedBox(height: 4.0),
                      Expanded(child: Container()),
                      // CommonDivider(),
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
                                    vm!.loanRequest!.amountRequested! /
                                        vm!.loanRequest!.repaymentPeriod!,
                                    currencyCode: '',
                                  ),
                                  fontSize: 20.0,
                                  textColor: Theme.of(ctx).colorScheme.primary,
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
                                  '${vm!.loanRequest!.repaymentPeriod!.round()} Months',
                                  fontSize: 20.0,
                                  textColor: Theme.of(ctx).colorScheme.primary,
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                LongText(
                                  'Business Name',
                                  fontSize: 10.0,
                                  textColor: Colors.grey.shade700,
                                ),
                                const SizedBox(height: 4.0),
                                DecoratedText(
                                  vm!.loanRequest!.businessProfile!.name,
                                  fontSize: 20.0,
                                  textColor: Theme.of(ctx).colorScheme.primary,
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
                                  'Reason',
                                  fontSize: 10.0,
                                  textColor: Colors.grey.shade700,
                                ),
                                const SizedBox(height: 4.0),
                                DecoratedText(
                                  vm!.loanRequest!.loanPurpose,
                                  fontSize: 20.0,
                                  textColor: Theme.of(ctx).colorScheme.primary,
                                  alignment: Alignment.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      const CommonDivider(width: 0.5),
                      const SizedBox(height: 4.0),
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
                            TextFormatter.toStringCurrency(
                              vm!.loanRequest!.amountRequested,
                              currencyCode: '',
                            ),
                            fontSize: 24.0,
                            textColor: Theme.of(ctx).colorScheme.secondary,
                            alignment: Alignment.bottomCenter,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ButtonPrimary(
                  text: 'Submit Request',
                  textColor: Colors.white,
                  buttonColor: Theme.of(ctx).colorScheme.primary,
                  onTap: (c) async {
                    vm!.submitLoanRequest(
                      vm!.loanRequest,
                      parentContext ?? ctx,
                    );
                  },
                ),
              ],
            ),
          )
        : const AppProgressIndicator(),
  );
}
