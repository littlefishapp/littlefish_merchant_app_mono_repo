import 'package:equatable/equatable.dart';

class PaywallBanner extends Equatable {
  final bool paywallEnabled;
  final String startScript;
  final String pendingHeader;
  final String pendingBody;
  final String enabledScript;
  final String startControl;
  final String id;

  const PaywallBanner({
    this.paywallEnabled = false,
    this.startScript = '',
    this.pendingHeader = '',
    this.pendingBody = '',
    this.enabledScript = '',
    this.startControl = '',
    this.id = '',
  });

  PaywallBanner copyWith({
    bool? paywallEnabled,
    String? startScript,
    String? pendingHeader,
    String? pendingBody,
    String? enabledScript,
    String? startControl,
    String? id,
  }) {
    return PaywallBanner(
      paywallEnabled: paywallEnabled ?? this.paywallEnabled,
      startScript: startScript ?? this.startScript,
      pendingHeader: pendingHeader ?? this.pendingHeader,
      pendingBody: pendingBody ?? this.pendingBody,
      enabledScript: enabledScript ?? this.enabledScript,
      startControl: startControl ?? this.startControl,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
    paywallEnabled,
    startScript,
    pendingHeader,
    pendingBody,
    enabledScript,
    startControl,
    id,
  ];
}
