// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/finance/loan_request.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import 'package:littlefish_merchant/ui/finance/pages/submit_finance_page.dart';
import 'package:littlefish_merchant/ui/finance/viewmodels/finance_vm.dart';
import 'package:littlefish_merchant/ui/finance/widgets/finance_loan_calculator.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/email_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/mobile_number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

class FinanceWizzardPage extends StatefulWidget {
  static const String route = '/finance/apply';

  final FinanceVM? vm;

  const FinanceWizzardPage({Key? key, required this.vm}) : super(key: key);

  @override
  State<FinanceWizzardPage> createState() => _FinanceWizzardPageState();
}

class _FinanceWizzardPageState extends State<FinanceWizzardPage> {
  int currentStep = 0;
  LoanRequest? loanRequest;
  GlobalKey<FormState>? detailsKey;
  BusinessProfile? business;
  UserProfile? user;
  @override
  void initState() {
    detailsKey = GlobalKey();
    loanRequest = LoanRequest();
    business = widget.vm!.profile;
    user = widget.vm!.userProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vm!.loanRequest == null) widget.vm!.loanRequest = loanRequest;
    return AppSimpleAppScaffold(
      title: 'Request Loan',
      body: Theme(
        data: ThemeData(
          canvasColor: Colors.white,
          primaryColor: Theme.of(context).colorScheme.primary,
          // TODO(lampian): fix color
          // accentColor: Theme.of(context).colorScheme.secondary,
        ),
        child: Stepper(
          physics: const BouncingScrollPhysics(),
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepCancel: () {
            switch (currentStep) {
              case 0:
                Navigator.of(context).pop();
                break;
              default:
                setState(() {
                  currentStep--;
                });
            }
          },
          onStepContinue: () {
            switch (currentStep) {
              case 0:
                {
                  if ((loanRequest!.repaymentPeriod ?? 0) <= 0 ||
                      (loanRequest!.amountRequested ?? 0) <= 0) {
                    showMessageDialog(
                      context,
                      'Please enter an amount and the how long to borrow for',
                      LittleFishIcons.warning,
                    );
                  } else {
                    setState(() {
                      currentStep++;
                    });
                  }
                }
                break;
              case 1:
                {
                  if (loanRequest!.loanPurpose == null) {
                    showMessageDialog(
                      context,
                      'Please select the purpose of your loan',
                      LittleFishIcons.warning,
                    );
                  } else {
                    setState(() {
                      currentStep++;
                    });
                  }
                }
                break;
              case 2:
                {
                  if (!detailsKey!.currentState!.validate()) {
                    showMessageDialog(
                      context,
                      'Please make sure all fields are completed',
                      LittleFishIcons.warning,
                    );
                  } else {
                    loanRequest!.businessProfile = business;
                    loanRequest!.userProfile = user;
                    loanRequest!.score = widget.vm?.performanceScore;
                    widget.vm!.loanRequest = loanRequest;
                    showPopupDialog(
                      defaultPadding: false,
                      context: context,
                      content: SubmitFinancePage(
                        isEmbedded: true,
                        vm: widget.vm,
                        parentContext: context,
                      ),
                    );
                  }
                }
                break;
              default:
            }
          },
          steps: [
            Step(
              title: const Text('Amount'),
              state: currentStep == 0 ? StepState.editing : StepState.complete,
              subtitle: const Text('How much would you like to borrow?'),
              content: FinanceLoanCalculator(
                maxLoanAmount: widget.vm!.eligableLoanLimit,
                maxPeriod: widget.vm!.maxDuration,
                minPeriod: widget.vm!.minDuration,
                onAmountChanged: (value) =>
                    loanRequest!.amountRequested = value.roundToDouble(),
                onPeriodChanged: (value) =>
                    loanRequest!.repaymentPeriod = value.roundToDouble(),
              ),
              isActive: currentStep == 0,
            ),
            Step(
              title: const Text('Purpose'),
              state: currentStep > 1
                  ? StepState.complete
                  : currentStep == 1
                  ? StepState.editing
                  : StepState.indexed,
              subtitle: const Text('What is the loan for?'),
              content: financePurpose(context),
              isActive: currentStep == 1,
            ),
            Step(
              title: const Text('Submit'),
              state: currentStep > 2
                  ? StepState.complete
                  : currentStep == 2
                  ? StepState.editing
                  : StepState.indexed,
              subtitle: const Text('Confirm and submit your loan for approval'),
              content: submissonForm(context),
              isActive: currentStep == 2,
            ),
          ],
        ),
      ),
    );
  }

  Column financePurpose(context) {
    return Column(
      children: widget.vm!.reasons
          .map(
            (reason) => CheckboxListTile(
              title: Text(
                reason.name!,
                style: TextStyle(
                  fontWeight: widget.vm!.selectedReason == reason
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              secondary: Icon(reason.icon),
              activeColor: Theme.of(context).colorScheme.primary,
              selected: widget.vm!.selectedReason == reason,
              value: widget.vm!.selectedReason == reason,
              onChanged: (value) {
                if (value!) {
                  widget.vm!.selectedReason = reason;
                  loanRequest!.loanPurpose = reason.name;
                } else {
                  widget.vm!.selectedReason = null;
                  loanRequest!.loanPurpose = null;
                }

                if (mounted) setState(() {});
              },
            ),
          )
          .toList(),
    );
  }

  Form submissonForm(context) {
    return Form(
      key: detailsKey,
      child: Column(
        children: <Widget>[
          StringFormField(
            hintText: 'Requesting Business',
            key: const Key('requestedBusiness'),
            labelText: 'Requesting Business',
            onSaveValue: (value) {},
            enabled: false,
            initialValue: business!.name,
          ),
          StringFormField(
            hintText: 'Business Registration Number',
            key: const Key('registration'),
            labelText: 'Business Registraton Number',
            maxLength: 15,
            onFieldSubmitted: (value) {
              business!.registrationNumber = value;
            },
            onSaveValue: (value) {
              business!.registrationNumber = value;
            },
            initialValue: business!.registrationNumber,
          ),
          StringFormField(
            hintText: 'Tax / VAT Number',
            key: const Key('taxNumber'),
            labelText: 'Tax Number',
            maxLength: 15,
            onFieldSubmitted: (value) {
              business!.taxNumber = value;
            },
            onSaveValue: (value) {
              business!.taxNumber = value;
            },
            initialValue: business!.taxNumber,
          ),
          StringFormField(
            hintText: 'Requested By',
            key: const Key('requestedBy'),
            labelText: 'Requested By',
            onSaveValue: (value) {},
            enabled: false,
            initialValue: user!.displayName,
          ),
          StringFormField(
            hintText: 'Enter your National ID Number',
            key: const Key('nationalID'),
            labelText: 'National Identity Number',
            maxLength: 15,
            onFieldSubmitted: (value) {
              loanRequest!.requesterIdNumber = value;
            },
            onSaveValue: (value) {
              loanRequest!.requesterIdNumber = value;
            },
          ),
          EmailFormField(
            textColor: Theme.of(context).colorScheme.onBackground,
            iconColor: Theme.of(context).colorScheme.onBackground,
            hintColor: Theme.of(context).colorScheme.onBackground,
            hintText: 'Your email address',
            key: const Key('email'),
            labelText: 'Requestor Email Address',
            onFieldSubmitted: (value) {
              user!.email = value;
            },
            onSaveValue: (value) {
              user!.email = value;
            },
            initialValue: user!.email,
          ),
          MobileNumberFormField(
            hintText: 'Your mobile number',
            key: const Key('mobile'),
            labelText: 'Requestor Mobile Number',
            onFieldSubmitted: (value) {
              user!.mobileNumber = value;
            },
            onSaveValue: (value) {
              user!.mobileNumber = value;
            },
            initialValue: user!.mobileNumber,
            country: LocaleProvider.instance.currentLocale,
          ),
        ],
      ),
    );
  }
}
