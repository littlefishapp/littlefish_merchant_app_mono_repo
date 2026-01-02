import 'package:dartz/dartz.dart';
import 'package:littlefish_interfaces/pos_result_interface.dart';
import 'package:littlefish_interfaces/printer_gateway.dart';
import 'package:littlefish_interfaces/printer_request_interface.dart';

class NonePrinterGateway implements PrinterGateway {
  @override
  Future<Either<String, bool>> cutPaper() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> print(
    PrinterRequestInterface printerRequest,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> printString(
    String printerRequest,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> printBothCustomerAndMerchantCopy(
    String referenceNumber,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> printCustomerCopy(
    String referenceNumber,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> printMerchantCopy(
    String referenceNumber,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> printRefund(
    PrinterRequestInterface printerRequest,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> reprint(
    String referenceNumber,
  ) async {
    return const Left('Not implemented');
  }
}
