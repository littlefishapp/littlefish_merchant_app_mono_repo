import 'package:equatable/equatable.dart';

class CreatePaymentLinkRequest extends Equatable {
  final String businessId;
  final String linkName;
  final double amount;
  final String currency;
  final String description;
  final String customerFirstName;
  final String customerLastName;
  final String customerEmail;
  final String customerPhoneNumber;
  final String createdBy;

  const CreatePaymentLinkRequest({
    this.businessId = '',
    this.linkName = '',
    this.amount = 0.0,
    this.currency = '',
    this.description = '',
    this.customerFirstName = '',
    this.customerLastName = '',
    this.customerEmail = '',
    this.customerPhoneNumber = '',
    this.createdBy = '',
  });

  @override
  List<Object?> get props => [
    businessId,
    linkName,
    amount,
    currency,
    description,
    customerFirstName,
    customerLastName,
    customerEmail,
    customerPhoneNumber,
    createdBy,
  ];
}
