class ReceiptData {
  final String businessName;
  final String businessAddress;
  final String businessContactNumber;
  final String businessLogo;
  final String customerName;
  final String customerEmail;
  final String customerContactNumber;
  final String saleDescription;
  final double transactionNumber;
  final String sellerName;
  final String footer;
  final String header;
  final List<LineItem> items;
  final String qrCode;
  final bool showQRCode;
  final double totalDiscount;
  final double totalTax;
  final double cartTotal;
  final double totalQuantity;

  bool get hasQRCode => qrCode.isNotEmpty;

  ReceiptData({
    this.businessName = '',
    this.cartTotal = 0,
    this.totalDiscount = 0,
    this.totalQuantity = 0,
    this.transactionNumber = 0,
    this.sellerName = '',
    this.items = const [],
    this.showQRCode = false,
    this.saleDescription = '',
    this.businessAddress = '',
    this.businessContactNumber = '',
    this.businessLogo = '',
    this.customerContactNumber = '',
    this.customerEmail = '',
    this.customerName = '',
    this.qrCode = '',
    this.totalTax = 0,
    this.footer = '',
    this.header = '',
  });
}

class LineItem {
  final String productName;
  final double quantity;
  final double value;

  LineItem({
    required this.productName,
    required this.quantity,
    required this.value,
  });
}
