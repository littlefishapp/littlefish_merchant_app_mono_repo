// Package imports:
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';

part 'business_expense.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class BusinessExpense extends BusinessDataItem {
  BusinessExpense({
    this.amount,
    this.beneficiary,
    this.beneficiaryId,
    this.creditorName,
    this.expenseType,
    this.invoiceId,
    this.isNew = false,
    this.sourceOfFunds,
    this.reference,
  });

  BusinessExpense.create() {
    id = const Uuid().v4();
    isNew = true;
    enabled = true;
    deleted = false;
    dateCreated = DateTime.now().toUtc();
    expenseType = ExpenseType.general;
    sourceOfFunds = SourceOfFunds.cash;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? isNew;

  double? amount;

  String? beneficiary;

  String? beneficiaryId;

  String? invoiceId;

  String? reference;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? newID;

  ExpenseType? expenseType;

  SourceOfFunds? sourceOfFunds;

  String? creditorName;

  factory BusinessExpense.fromJson(Map<String, dynamic> json) =>
      _$BusinessExpenseFromJson(json)..newID = json['id'];

  Map<String, dynamic> toJson() => _$BusinessExpenseToJson(this);
}

enum ExpenseType {
  @JsonValue(0)
  invoice,
  @JsonValue(1)
  wages,
  @JsonValue(2)
  bill,
  @JsonValue(3)
  general,
  @JsonValue(4)
  refund,
}

enum SourceOfFunds {
  @JsonValue(0)
  cash,
  @JsonValue(1)
  eft,
  @JsonValue(2)
  credit,
  @JsonValue(3)
  mobileMoney,
  @JsonValue(4)
  card,
  @JsonValue(5)
  other,
}
