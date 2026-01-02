// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart' show IterableExtension;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/finance/loan_request.dart';
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/finance_api/loan_service.dart';
import 'package:littlefish_merchant/services/finance_api/score_service.dart';
import 'package:littlefish_merchant/ui/finance/finance_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class FinanceVM extends StoreViewModel<AppState> {
  FinanceVM.fromStore(Store<AppState> store) : super.fromStore(store);

  double? totalLoanLimit;

  double? eligableLoanLimit;

  double? eligabilityScore;

  double? minDuration;

  double? maxDuration;

  double? interestRate;

  double? riskPremium;

  LoanRequest? loanRequest;

  double? periodRisk;

  BusinessProfile? profile;

  UserProfile? userProfile;

  FinancePurpose? selectedReason;

  late List<FinancePurpose> reasons;

  late BusinessPerformanceScore performanceScore;

  ScoreService? scoreService;

  late LoanService loanService;

  Map<double, Color> get colorMap => {
    4: Colors.red,
    5: Colors.orange,
    6: Colors.yellow,
    10: Colors.green,
  };

  Color? getColor(double? firstScore, double? secondScore) {
    if (firstScore == null ||
        secondScore == null ||
        secondScore == 0 ||
        firstScore > secondScore) {
      return null;
    }
    double percent = (firstScore / secondScore) * 10;

    var value = colorMap.entries
        .firstWhereOrNull((x) => x.key >= percent)
        ?.value;

    return value;
  }

  Color? get mapColor {
    if (performanceScore.finalScore == null) return Colors.red;

    return colorMap.entries
        .firstWhereOrNull((x) => x.key <= performanceScore.finalScore!)
        ?.value;
  }

  late Function(LoanRequest? request, BuildContext ctx) submitLoanRequest;

  late Function(double? score, double? loanLimit) setEligibleLimit;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    scoreService = ScoreService.fromStore(store);
    loanService = LoanService.fromStore(store);
    isLoading = false;
    profile = state!.businessState.profile;

    userProfile = state!.userProfile;

    setEligibleLimit = (eligibility, loanLimit) {
      totalLoanLimit = loanLimit;
      eligabilityScore = eligibility;
      eligableLoanLimit = (loanLimit! * (eligibility! / 100)).roundToDouble();
    };

    submitLoanRequest = (LoanRequest? request, BuildContext ctx) async {
      isLoading = true;

      loanService
          .submitLoanRequest(request: request)
          .then((result) {
            isLoading = false;

            if (result) {
              showMessageDialog(
                ctx,
                'Congratulations, your loan request has been sent',
                LittleFishIcons.info,
              ).then((v) {
                Navigator.of(ctx).pushNamedAndRemoveUntil(
                  FinancePage.route,
                  ModalRoute.withName('/'),
                );
              });
            } else {
              showMessageDialog(
                ctx,
                'Something went wrong please try sending the request again',
                LittleFishIcons.error,
              );
            }
          })
          .catchError((error) {
            showMessageDialog(
              ctx,
              'Something went wrong wrong, please try again later',
              LittleFishIcons.error,
            );
            reportCheckedError(error);
            isLoading = false;
          })
          .whenComplete(() {
            isLoading = false;
          });
    };

    minDuration = 1;
    maxDuration = 12;

    riskPremium = 1;
    interestRate = 7;
    periodRisk = 1;

    reasons = purposeList();
  }
}

List<FinancePurpose> purposeList() => [
  FinancePurpose(name: 'Stock', icon: MdiIcons.truckDelivery),
  FinancePurpose(name: 'Business Premises', icon: MdiIcons.officeBuilding),
  FinancePurpose(name: 'Equipment', icon: MdiIcons.washingMachine),
  FinancePurpose(name: 'Service Contract / Tender', icon: MdiIcons.sale),
  FinancePurpose(name: 'Staff Expenses', icon: MdiIcons.account),
  FinancePurpose(name: 'Insurance Premiums', icon: MdiIcons.prescription),
  FinancePurpose(name: 'Personal / Family', icon: Icons.nature_people),
  FinancePurpose(name: 'Investment', icon: MdiIcons.walletPlus),
  FinancePurpose(name: 'Vehicle', icon: MdiIcons.car),
];

class FinancePurpose {
  String? name;

  IconData? icon;

  FinancePurpose({this.icon, this.name});
}
