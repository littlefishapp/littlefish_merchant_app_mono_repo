// Flutter imports:
import 'package:flutter/cupertino.dart';

abstract class CommonViewModel extends ChangeNotifier {
  CommonViewModel({this.context});

  BuildContext? context;

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  set isLoading(value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  Future<void>? populate({bool refresh = false});

  void refresh({BuildContext? context}) async {}
}
