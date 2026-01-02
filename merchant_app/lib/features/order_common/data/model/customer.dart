import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_merchant/features/order_common/data/model/shipping_address.dart';

part 'customer.g.dart';

@JsonSerializable(explicitToJson: true)
class Customer extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String businessId;
  final String email;
  final String referenceId;
  final String mobileNumber;
  final ShippingAddress shippingAddress;

  const Customer({
    this.firstName = '',
    this.lastName = '',
    this.businessId = '',
    this.id = '',
    this.email = '',
    this.referenceId = '',
    this.mobileNumber = '',
    this.shippingAddress = const ShippingAddress(),
  });

  Customer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? businessId,
    String? email,
    String? referenceId,
    String? mobileNumber,
    ShippingAddress? shippingAddress,
  }) {
    return Customer(
      businessId: businessId ?? this.businessId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      referenceId: referenceId ?? this.referenceId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    businessId,
    email,
    referenceId,
    mobileNumber,
    shippingAddress,
  ];
}
