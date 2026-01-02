class ButtonStyleData {
  final double width;
  final double radius;

  const ButtonStyleData({this.width = 1.0, this.radius = 8.0});

  ButtonStyleData copyWith({double? width, double? radius}) {
    return ButtonStyleData(
      width: width ?? this.width,
      radius: radius ?? this.radius,
    );
  }
}
