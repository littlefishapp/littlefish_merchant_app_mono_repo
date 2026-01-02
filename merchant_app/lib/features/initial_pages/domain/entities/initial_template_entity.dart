import 'package:equatable/equatable.dart';

class InitialTemplateEntity extends Equatable {
  final String landing;
  final String initial;
  final String loading;
  final String login;

  const InitialTemplateEntity({
    this.landing = 'default',
    this.initial = 'default',
    this.loading = 'default',
    this.login = 'default',
  });

  @override
  List<Object?> get props => [landing, initial, loading, login];

  InitialTemplateEntity copyWith({
    String? landing,
    String? initial,
    String? loading,
    String? login,
  }) {
    return InitialTemplateEntity(
      landing: landing ?? this.landing,
      initial: initial ?? this.initial,
      loading: loading ?? this.loading,
      login: login ?? this.login,
    );
  }
}
