import 'package:dartz/dartz.dart';
import 'package:littlefish_interfaces/scan_result_interface.dart';
import 'package:littlefish_interfaces/scanner_gateway.dart';

class NoneScannerGateway implements ScannerGateway {
  @override
  Future<Either<String, ScanResultInterface>> scan() async {
    return const Left('Not implemented');
  }

  @override
  Future<Either<String, ScanResultInterface>> scanHW() async {
    return const Left('Not implemented');
  }
}
