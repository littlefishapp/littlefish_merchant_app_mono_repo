// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import 'package:littlefish_merchant/models/suppliers/supplier_invoice.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

part 'invoice_state.g.dart';

@immutable
@JsonSerializable()
abstract class InvoiceState
    implements Built<InvoiceState, InvoiceStateBuilder> {
  const InvoiceState._();

  factory InvoiceState() => _$InvoiceState._(
    hasError: false,
    isLoading: false,
    errorMessage: null,
    invoices: const <SupplierInvoice>[],
  );

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get isLoading;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool? get hasError;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get errorMessage;

  List<SupplierInvoice>? get invoices;
}

abstract class InvoiceUIState
    implements Built<InvoiceUIState, InvoiceUIStateBuilder> {
  factory InvoiceUIState() {
    return _$InvoiceUIState._(
      item: UIEntityState<SupplierInvoice>(
        SupplierInvoice.create(),
        isNew: true,
      ),
    );
  }

  InvoiceUIState._();

  UIEntityState<SupplierInvoice?>? get item;

  bool get isNew => item?.isNew ?? false;
}
