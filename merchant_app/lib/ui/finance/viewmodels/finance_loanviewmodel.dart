// Project imports:
import 'package:littlefish_merchant/models/shared/common_view_model.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';

class LoanViewModel extends CommonViewModel {
  LoanViewModel({
    this.interestRate = 9,
    this.loanAmount,
    this.maximumLoanAmount,
    this.minimumLoanAmount,
    this.monthCount,
    this.maxPeriod,
    this.minPeriod,
  });

  double? loanAmount, interestRate;

  double? maximumLoanAmount, minimumLoanAmount;

  int? maxPeriod, minPeriod;

  int? monthCount;

  double get interestAmount {
    return (loanAmount ?? 0) * (interestRate! / 100);
  }

  double get totalRepayment {
    return (((loanAmount ?? 0) + interestAmount));
  }

  double get averageRepayment {
    if (totalRepayment <= 0) return 0.0;

    return totalRepayment / monthCount!;
  }

  Future<FormResult> validate() async {
    var isValid =
        loanAmount! > 0 &&
        monthCount! > 0 &&
        averageRepayment > 0 &&
        interestAmount > 0;

    return FormResult(success: isValid);
  }

  @override
  Future<void>? populate({bool refresh = false}) {
    // TODO: implement populate
    return null;
  }
}

enum ContributionSchedule { monthly, fortnightly, weekly, daily }
