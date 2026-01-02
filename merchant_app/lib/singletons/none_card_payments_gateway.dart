import 'package:dartz/dartz.dart';
import 'package:littlefish_interfaces/card_payment_gateway.dart';
import 'package:littlefish_interfaces/pos_result_interface.dart';

class NoneCardPaymentsGateway implements CardPaymentGateway {
  @override
  Future<Either<String, POSResultInterface>> charge(String chargeAmount) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> chargeAndCashBack(
    String chargeAmount,
    String cashbackAmount,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> closeBatch() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, Map<String, String>>> createTerminal(
    Map<String, dynamic> parameters,
  ) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, bool>> cutPaper() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> disposeTerminal() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, int>> getBatchNo() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, Map<String, String>>> getTerminalInfo() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> inquiry() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> lastReceipt() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> refund(String amount) async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, POSResultInterface>> withdrawal(String amount) async {
    return const Left('Not implemented');
  }
}
