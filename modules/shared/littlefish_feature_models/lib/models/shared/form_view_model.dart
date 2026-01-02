// Flutter imports:
import 'package:flutter/widgets.dart';

class FormManager {
  FormManager(this.key);

  GlobalKey<FormState>? key;

  Map<String?, FocusNode>? _focusNodes;

  Map<String?, FocusNode>? get focusNodes {
    _focusNodes ??= <String?, FocusNode>{};

    return _focusNodes;
  }

  set focusNodes(value) {
    _focusNodes = value;
  }

  FocusNode setFocusNode(String? key) {
    _focusNodes ??= <String?, FocusNode>{};
    var result = _focusNodes!.putIfAbsent(key, () => FocusNode());

    return result;
  }
}

abstract class FormViewModel with ChangeNotifier {
  FormViewModel(this.formKey, {this.context}) {
    _focusNodes = <String, FocusNode>{};
  }

  GlobalKey<FormState>? formKey;

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

  Map<String, FocusNode>? _focusNodes;

  Map<String, FocusNode>? get focusNodes {
    _focusNodes ??= <String, FocusNode>{};

    return _focusNodes;
  }

  set focusNodes(value) {
    _focusNodes = value;
  }

  FocusNode setFocusNode(String key) {
    var result = _focusNodes!.putIfAbsent(key, () => FocusNode());

    return result;
  }

  Future<FormResult?> validate({BuildContext? context});

  Future<FormResult?> save({BuildContext? context});

  void refresh() {
    notifyListeners();
  }
}

class BasicFormModel extends FormViewModel {
  BasicFormModel(GlobalKey<FormState>? formKey) : super(formKey, context: null);

  @override
  Future<FormResult?> save({BuildContext? context}) async {
    return null;
  }

  @override
  Future<FormResult?> validate({BuildContext? context}) async {
    return null;
  }
}

class FormResult {
  FormResult({this.success, this.message});

  bool? success;

  String? message;
}
