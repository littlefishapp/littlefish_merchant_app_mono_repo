import 'package:equatable/equatable.dart';

class OrganisationInfoEntity extends Equatable {
  final String name;
  final String domain;
  const OrganisationInfoEntity({required this.name, required this.domain});
  @override
  List<Object?> get props => [name, domain];
  OrganisationInfoEntity copyWith({String? name, String? domain}) {
    return OrganisationInfoEntity(
      name: name ?? this.name,
      domain: domain ?? this.domain,
    );
  }
}
