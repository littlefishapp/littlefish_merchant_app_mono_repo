// Dart imports:
import 'dart:io';

// Package imports:
import 'package:fast_contacts/fast_contacts.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import '../../features/ecommerce_shared/models/store/store.dart';
import 'package:littlefish_merchant/features/order_common/data/model/customer.dart'
    as order_models;

part 'customer.g.dart';

@JsonSerializable()
@IsoDateTimeConverter()
class Customer extends BusinessDataItem {
  Customer({
    this.email,
    this.firstName,
    this.id,
    this.lastName,
    this.mobileNumber,
    this.internationalNumber,
    this.identityNumber,
    this.notes,
    this.lastPurchaseDate,
    this.averageSaleValue,
    this.lastSaleValue,
    this.totalSaleCount,
    this.totalSaleValue,
    this.profileImageUri,
    this.address,
    this.creditBalance,
    this.companyAddress,
    this.companyContactNumber,
    this.companyName,
    this.companyRegVatNumber,
  }) : super(id: id);

  Customer.create() {
    id = const Uuid().v4();
    dateCreated = DateTime.now().toUtc();
    address = StoreAddress();
    enabled = true;
    deleted = false;
    notes = [];
  }

  factory Customer.fromContact(Contact contact) => Customer(
    id: const Uuid().v4(),
    firstName: contact.displayName,
    lastName: contact.structuredName?.familyName,
    mobileNumber: contact.phones.isNotEmpty
        ? contact.phones.first.number
        : null,
    email: contact.emails.isNotEmpty ? contact.emails.first.address : null,
    address: StoreAddress(),
  );

  factory Customer.fromOrderCustomer(order_models.Customer? c) {
    return Customer(
      id: c?.id,
      firstName: c?.firstName,
      lastName: c?.lastName,
      email: c?.email,
      mobileNumber: c?.mobileNumber,
      address: StoreAddress(
        addressLine1: c?.shippingAddress.line1,
        addressLine2: c?.shippingAddress.line2,
        city: c?.shippingAddress.city,
        state: c?.shippingAddress.province,
        country: c?.shippingAddress.country,
        postalCode: c?.shippingAddress.zipCode,
      ),
    );
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  File? customerFile;

  // ignore: annotate_overrides, overridden_fields
  String? id;
  String? firstName;
  String? lastName;

  @override
  String? get displayName {
    if (firstName == null || firstName!.isEmpty) return null;

    return "$firstName${lastName == null || lastName!.isEmpty ? "" : " $lastName"}";
  }

  String? profileImageUri;

  String? identityNumber;

  String? mobileNumber, internationalNumber;

  String? email;

  bool get userVerified =>
      isNotBlank(mobileNumber) || isNotBlank(identityNumber);

  @JsonKey(defaultValue: 0)
  double? lastSaleValue, totalSaleValue, averageSaleValue, creditBalance;

  @JsonKey(defaultValue: 0)
  int? totalSaleCount;

  @JsonKey(includeIfNull: true)
  DateTime? lastPurchaseDate;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get lastPurchaseDescription {
    if (lastPurchaseDate == null) return 'No purchase history';
    return 'Last purchase on ${TextFormatter.toShortDate(dateTime: lastPurchaseDate)}';
  }

  List<String>? notes;

  StoreAddress? address;

  String? companyName, companyRegVatNumber, companyContactNumber;

  StoreAddress? companyAddress;

  List<CustomerLedgerEntry>? customerLedgerEntries;

  List<CheckoutTransaction>? transactionHistory;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class CustomerLedgerEntry {
  String? entryType;
  String? customerId, id, businessId, addedBy, transactionId;
  String? status;
  double? amount;
  DateTime? dateAdded;

  bool get isCancelled => status == 'cancelled';
  bool get isDebit => entryType!.toLowerCase() == 'debit';

  CustomerLedgerEntry({
    this.entryType,
    this.customerId,
    this.addedBy,
    this.amount,
    this.businessId,
    this.dateAdded,
    this.id,
    this.transactionId,
    this.status,
  });

  factory CustomerLedgerEntry.fromJson(Map<String, dynamic> json) =>
      _$CustomerLedgerEntryFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerLedgerEntryToJson(this);
}
