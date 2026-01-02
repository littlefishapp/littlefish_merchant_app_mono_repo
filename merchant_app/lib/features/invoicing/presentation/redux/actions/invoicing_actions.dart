import 'package:littlefish_merchant/models/sales/checkout/checkout_discount.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';

import '../../../../../models/stock/stock_product.dart';
import '../../../../order_common/data/model/order.dart';

class LoadInvoicesAction {}

class ResetAndLoadInvoicesAction {}

class ClearInvoicesAction {}

class ResetInvoicesStateAction {}

class LoadMoreInvoicesAction {
  final int offset;
  final int limit;

  LoadMoreInvoicesAction({required this.offset, required this.limit});
}

class AppendInvoicesSuccessAction {
  final List<Order> invoices;
  final int offset;
  final int totalRecords;

  AppendInvoicesSuccessAction(this.invoices, this.offset, this.totalRecords);
}

class LoadInvoicesSuccessAction {
  final List<Order> invoices;
  final int offset;
  final int totalRecords;

  LoadInvoicesSuccessAction(this.invoices, this.offset, this.totalRecords);
}

class LoadInvoicesFailureAction {
  final GeneralError error;
  LoadInvoicesFailureAction(this.error);
}

class SetInvoicesLoadingAction {
  final bool value;
  SetInvoicesLoadingAction(this.value);
}

class UpdateInvoiceStatusAction {
  final String invoiceId;
  final OrderStatus newStatus;

  UpdateInvoiceStatusAction({required this.invoiceId, required this.newStatus});
}

class SetInvoiceDiscountAction {
  final CheckoutDiscount discount;

  SetInvoiceDiscountAction(this.discount);
}

class SetInvoiceTotalAmountAction {
  final double total;

  SetInvoiceTotalAmountAction(this.total);
}

class SetInvoiceDueDateAction {
  final DateTime? dueDate;
  SetInvoiceDueDateAction(this.dueDate);
}

class SetInvoiceSelectedProductsAction {
  final List<StockProduct> products;
  SetInvoiceSelectedProductsAction(this.products);
}

class SetInvoiceNotesAction {
  final String notes;
  SetInvoiceNotesAction(this.notes);
}

class SetSelectedQuantitiesAction {
  final Map<String, int> quantities;
  SetSelectedQuantitiesAction(this.quantities);
}

class ResetInvoicingStateAction {}
