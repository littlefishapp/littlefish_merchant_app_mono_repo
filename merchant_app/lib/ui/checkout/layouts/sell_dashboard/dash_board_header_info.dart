class DashBoardHeaderInfo {
  final String introText;
  final String titleNormal;
  final String titleBold;
  final String subtitle;
  final String subtitle2Left;
  final String subtitle2Right;
  final String tileFormat;

  const DashBoardHeaderInfo({
    this.introText = '',
    this.titleNormal = '',
    this.titleBold = '',
    this.subtitle = '',
    this.subtitle2Left = '',
    this.subtitle2Right = '',
    this.tileFormat = '',
  });

  DashBoardHeaderInfo fromJson(Map<String, dynamic> json) {
    return DashBoardHeaderInfo(
      introText: json['introText'] ?? '',
      titleNormal: json['titleNormal'] ?? '',
      titleBold: json['titleBold'] ?? '',
      subtitle: json['subtitle'] ?? '',
      subtitle2Left: json['subtitle2Left'] ?? '',
      subtitle2Right: json['subtitle2Right'] ?? '',
      tileFormat: json['tileFormat'] ?? '',
    );
  }

  DashBoardHeaderInfo copyWith({
    String? introText,
    String? titleNormal,
    String? titleBold,
    String? subtitle,
    String? subtitle2Left,
    String? subtitle2Right,
    String? tileFormat,
  }) {
    return DashBoardHeaderInfo(
      introText: introText ?? this.introText,
      titleNormal: titleNormal ?? this.titleNormal,
      titleBold: titleBold ?? this.titleBold,
      subtitle: subtitle ?? this.subtitle,
      subtitle2Left: subtitle2Left ?? this.subtitle2Left,
      subtitle2Right: subtitle2Right ?? this.subtitle2Right,
      tileFormat: tileFormat ?? this.tileFormat,
    );
  }

  Map<String, String> toJson() {
    return {
      'introText': introText,
      'titleNormal': titleNormal,
      'titleBold': titleBold,
      'subtitle': subtitle,
      'subtitle2Left': subtitle2Left,
      'subtitle2Right': subtitle2Right,
      'tileFormat': tileFormat,
    };
  }
}
