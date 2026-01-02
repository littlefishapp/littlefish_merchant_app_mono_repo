// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postalCode;
  String? country;
  dynamic location;

  Address({
    this.address1,
    this.address2,
    this.city,
    this.postalCode,
    this.state,
    this.country,
    this.location,
  });

  Address copyWith({
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    dynamic location,
  }) {
    return Address(
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      location: location ?? this.location,
    );
  }

  String get address {
    var formattedAddress = formatAddress();
    if (formattedAddress.isEmpty) {
      return 'No Address Information';
    } else {
      return formattedAddress;
    }
  }

  bool get isAddressEmpty {
    var formattedAddress = formatAddress();
    return formattedAddress.isEmpty;
  }

  String formatAddress({String delimiter = ', '}) {
    var str = '';

    if (address1 != null && address1!.isNotEmpty) {
      str += address1! + delimiter;
    }
    if (address2 != null && address2!.isNotEmpty) {
      str += address2! + delimiter;
    }

    if (city != null && city!.isNotEmpty) {
      str += city! + delimiter;
    }

    if (state != null && state!.isNotEmpty) {
      str += state! + delimiter;
    }

    if (postalCode != null && postalCode!.isNotEmpty) {
      str += postalCode!;
    }

    return str.trim();
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() {
    final data = _$AddressToJson(this);
    data.remove('location');
    return data;
  }
}
