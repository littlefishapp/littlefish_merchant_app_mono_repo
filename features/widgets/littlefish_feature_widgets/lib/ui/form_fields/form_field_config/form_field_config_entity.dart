import 'package:equatable/equatable.dart';

class FormFieldConfigEntity extends Equatable {
  final String hintTextStyle;

  const FormFieldConfigEntity({this.hintTextStyle = ''});

  @override
  List<Object?> get props => [hintTextStyle];
  FormFieldConfigEntity copyWith({String? hintTextStyle}) {
    return FormFieldConfigEntity(
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
    );
  }

  @override
  String toString() {
    return 'FormFieldConfigEntity(hintTextStyle: $hintTextStyle)';
  }
}
