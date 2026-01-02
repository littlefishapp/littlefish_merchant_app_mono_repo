// Flutter imports:

// Package imports:
import 'package:json_annotation/json_annotation.dart';

part 'workspace.g.dart';

@JsonSerializable()
class Workspace {
  String name;
  List<NavbarConfigItem> navbarConfig;

  Workspace({required this.name, required this.navbarConfig});

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);
  Map<String, dynamic> toJson() => _$WorkspaceToJson(this);
}

@JsonSerializable()
class NavbarConfigItem {
  String pageType;
  String? description;

  NavbarConfigItem({required this.pageType, this.description});

  factory NavbarConfigItem.fromJson(Map<String, dynamic> json) =>
      _$NavbarConfigItemFromJson(json);

  Map<String, dynamic> toJson() => _$NavbarConfigItemToJson(this);
}
