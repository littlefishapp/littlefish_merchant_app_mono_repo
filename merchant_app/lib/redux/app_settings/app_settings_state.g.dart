// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppSettingsState extends AppSettingsState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final SalesTax? salesTax;
  @override
  final List<SalesTax>? salesTaxesList;
  @override
  final List<VatLevel>? vatLevelsList;
  @override
  final OrderSetting? orderSettings;
  @override
  final bool? allowTickets;
  @override
  final bool? allowStoreCredit;
  @override
  final List<Report>? userReports;
  @override
  final String? reportVersion;
  @override
  final Report? selectedReport;
  @override
  final List<PaymentType> paymentTypes;
  @override
  final String? homeContentVersion;
  @override
  final String? appFlavor;
  @override
  final material.ThemeData? appTheme;
  @override
  final String? appUseCase;
  @override
  final String? appEnvironment;
  @override
  final String? appIntegrityCheck;
  @override
  final String? sslFingerPrint;
  @override
  final LoyaltySetting? loyaltySettings;
  @override
  final String? appVersion;
  @override
  final String? buildNumber;
  @override
  final String? appName;
  @override
  final String? packageName;

  factory _$AppSettingsState([
    void Function(AppSettingsStateBuilder)? updates,
  ]) => (AppSettingsStateBuilder()..update(updates))._build();

  _$AppSettingsState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.salesTax,
    this.salesTaxesList,
    this.vatLevelsList,
    this.orderSettings,
    this.allowTickets,
    this.allowStoreCredit,
    this.userReports,
    this.reportVersion,
    this.selectedReport,
    required this.paymentTypes,
    this.homeContentVersion,
    this.appFlavor,
    this.appTheme,
    this.appUseCase,
    this.appEnvironment,
    this.appIntegrityCheck,
    this.sslFingerPrint,
    this.loyaltySettings,
    this.appVersion,
    this.buildNumber,
    this.appName,
    this.packageName,
  }) : super._();
  @override
  AppSettingsState rebuild(void Function(AppSettingsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppSettingsStateBuilder toBuilder() =>
      AppSettingsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppSettingsState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        salesTax == other.salesTax &&
        salesTaxesList == other.salesTaxesList &&
        vatLevelsList == other.vatLevelsList &&
        orderSettings == other.orderSettings &&
        allowTickets == other.allowTickets &&
        allowStoreCredit == other.allowStoreCredit &&
        userReports == other.userReports &&
        reportVersion == other.reportVersion &&
        selectedReport == other.selectedReport &&
        paymentTypes == other.paymentTypes &&
        homeContentVersion == other.homeContentVersion &&
        appFlavor == other.appFlavor &&
        appTheme == other.appTheme &&
        appUseCase == other.appUseCase &&
        appEnvironment == other.appEnvironment &&
        appIntegrityCheck == other.appIntegrityCheck &&
        sslFingerPrint == other.sslFingerPrint &&
        loyaltySettings == other.loyaltySettings &&
        appVersion == other.appVersion &&
        buildNumber == other.buildNumber &&
        appName == other.appName &&
        packageName == other.packageName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, salesTax.hashCode);
    _$hash = $jc(_$hash, salesTaxesList.hashCode);
    _$hash = $jc(_$hash, vatLevelsList.hashCode);
    _$hash = $jc(_$hash, orderSettings.hashCode);
    _$hash = $jc(_$hash, allowTickets.hashCode);
    _$hash = $jc(_$hash, allowStoreCredit.hashCode);
    _$hash = $jc(_$hash, userReports.hashCode);
    _$hash = $jc(_$hash, reportVersion.hashCode);
    _$hash = $jc(_$hash, selectedReport.hashCode);
    _$hash = $jc(_$hash, paymentTypes.hashCode);
    _$hash = $jc(_$hash, homeContentVersion.hashCode);
    _$hash = $jc(_$hash, appFlavor.hashCode);
    _$hash = $jc(_$hash, appTheme.hashCode);
    _$hash = $jc(_$hash, appUseCase.hashCode);
    _$hash = $jc(_$hash, appEnvironment.hashCode);
    _$hash = $jc(_$hash, appIntegrityCheck.hashCode);
    _$hash = $jc(_$hash, sslFingerPrint.hashCode);
    _$hash = $jc(_$hash, loyaltySettings.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jc(_$hash, buildNumber.hashCode);
    _$hash = $jc(_$hash, appName.hashCode);
    _$hash = $jc(_$hash, packageName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppSettingsState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('salesTax', salesTax)
          ..add('salesTaxesList', salesTaxesList)
          ..add('vatLevelsList', vatLevelsList)
          ..add('orderSettings', orderSettings)
          ..add('allowTickets', allowTickets)
          ..add('allowStoreCredit', allowStoreCredit)
          ..add('userReports', userReports)
          ..add('reportVersion', reportVersion)
          ..add('selectedReport', selectedReport)
          ..add('paymentTypes', paymentTypes)
          ..add('homeContentVersion', homeContentVersion)
          ..add('appFlavor', appFlavor)
          ..add('appTheme', appTheme)
          ..add('appUseCase', appUseCase)
          ..add('appEnvironment', appEnvironment)
          ..add('appIntegrityCheck', appIntegrityCheck)
          ..add('sslFingerPrint', sslFingerPrint)
          ..add('loyaltySettings', loyaltySettings)
          ..add('appVersion', appVersion)
          ..add('buildNumber', buildNumber)
          ..add('appName', appName)
          ..add('packageName', packageName))
        .toString();
  }
}

class AppSettingsStateBuilder
    implements Builder<AppSettingsState, AppSettingsStateBuilder> {
  _$AppSettingsState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  SalesTax? _salesTax;
  SalesTax? get salesTax => _$this._salesTax;
  set salesTax(SalesTax? salesTax) => _$this._salesTax = salesTax;

  List<SalesTax>? _salesTaxesList;
  List<SalesTax>? get salesTaxesList => _$this._salesTaxesList;
  set salesTaxesList(List<SalesTax>? salesTaxesList) =>
      _$this._salesTaxesList = salesTaxesList;

  List<VatLevel>? _vatLevelsList;
  List<VatLevel>? get vatLevelsList => _$this._vatLevelsList;
  set vatLevelsList(List<VatLevel>? vatLevelsList) =>
      _$this._vatLevelsList = vatLevelsList;

  OrderSetting? _orderSettings;
  OrderSetting? get orderSettings => _$this._orderSettings;
  set orderSettings(OrderSetting? orderSettings) =>
      _$this._orderSettings = orderSettings;

  bool? _allowTickets;
  bool? get allowTickets => _$this._allowTickets;
  set allowTickets(bool? allowTickets) => _$this._allowTickets = allowTickets;

  bool? _allowStoreCredit;
  bool? get allowStoreCredit => _$this._allowStoreCredit;
  set allowStoreCredit(bool? allowStoreCredit) =>
      _$this._allowStoreCredit = allowStoreCredit;

  List<Report>? _userReports;
  List<Report>? get userReports => _$this._userReports;
  set userReports(List<Report>? userReports) =>
      _$this._userReports = userReports;

  String? _reportVersion;
  String? get reportVersion => _$this._reportVersion;
  set reportVersion(String? reportVersion) =>
      _$this._reportVersion = reportVersion;

  Report? _selectedReport;
  Report? get selectedReport => _$this._selectedReport;
  set selectedReport(Report? selectedReport) =>
      _$this._selectedReport = selectedReport;

  List<PaymentType>? _paymentTypes;
  List<PaymentType>? get paymentTypes => _$this._paymentTypes;
  set paymentTypes(List<PaymentType>? paymentTypes) =>
      _$this._paymentTypes = paymentTypes;

  String? _homeContentVersion;
  String? get homeContentVersion => _$this._homeContentVersion;
  set homeContentVersion(String? homeContentVersion) =>
      _$this._homeContentVersion = homeContentVersion;

  String? _appFlavor;
  String? get appFlavor => _$this._appFlavor;
  set appFlavor(String? appFlavor) => _$this._appFlavor = appFlavor;

  material.ThemeData? _appTheme;
  material.ThemeData? get appTheme => _$this._appTheme;
  set appTheme(material.ThemeData? appTheme) => _$this._appTheme = appTheme;

  String? _appUseCase;
  String? get appUseCase => _$this._appUseCase;
  set appUseCase(String? appUseCase) => _$this._appUseCase = appUseCase;

  String? _appEnvironment;
  String? get appEnvironment => _$this._appEnvironment;
  set appEnvironment(String? appEnvironment) =>
      _$this._appEnvironment = appEnvironment;

  String? _appIntegrityCheck;
  String? get appIntegrityCheck => _$this._appIntegrityCheck;
  set appIntegrityCheck(String? appIntegrityCheck) =>
      _$this._appIntegrityCheck = appIntegrityCheck;

  String? _sslFingerPrint;
  String? get sslFingerPrint => _$this._sslFingerPrint;
  set sslFingerPrint(String? sslFingerPrint) =>
      _$this._sslFingerPrint = sslFingerPrint;

  LoyaltySetting? _loyaltySettings;
  LoyaltySetting? get loyaltySettings => _$this._loyaltySettings;
  set loyaltySettings(LoyaltySetting? loyaltySettings) =>
      _$this._loyaltySettings = loyaltySettings;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  String? _buildNumber;
  String? get buildNumber => _$this._buildNumber;
  set buildNumber(String? buildNumber) => _$this._buildNumber = buildNumber;

  String? _appName;
  String? get appName => _$this._appName;
  set appName(String? appName) => _$this._appName = appName;

  String? _packageName;
  String? get packageName => _$this._packageName;
  set packageName(String? packageName) => _$this._packageName = packageName;

  AppSettingsStateBuilder();

  AppSettingsStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _salesTax = $v.salesTax;
      _salesTaxesList = $v.salesTaxesList;
      _vatLevelsList = $v.vatLevelsList;
      _orderSettings = $v.orderSettings;
      _allowTickets = $v.allowTickets;
      _allowStoreCredit = $v.allowStoreCredit;
      _userReports = $v.userReports;
      _reportVersion = $v.reportVersion;
      _selectedReport = $v.selectedReport;
      _paymentTypes = $v.paymentTypes;
      _homeContentVersion = $v.homeContentVersion;
      _appFlavor = $v.appFlavor;
      _appTheme = $v.appTheme;
      _appUseCase = $v.appUseCase;
      _appEnvironment = $v.appEnvironment;
      _appIntegrityCheck = $v.appIntegrityCheck;
      _sslFingerPrint = $v.sslFingerPrint;
      _loyaltySettings = $v.loyaltySettings;
      _appVersion = $v.appVersion;
      _buildNumber = $v.buildNumber;
      _appName = $v.appName;
      _packageName = $v.packageName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppSettingsState other) {
    _$v = other as _$AppSettingsState;
  }

  @override
  void update(void Function(AppSettingsStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppSettingsState build() => _build();

  _$AppSettingsState _build() {
    final _$result =
        _$v ??
        _$AppSettingsState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          salesTax: salesTax,
          salesTaxesList: salesTaxesList,
          vatLevelsList: vatLevelsList,
          orderSettings: orderSettings,
          allowTickets: allowTickets,
          allowStoreCredit: allowStoreCredit,
          userReports: userReports,
          reportVersion: reportVersion,
          selectedReport: selectedReport,
          paymentTypes: BuiltValueNullFieldError.checkNotNull(
            paymentTypes,
            r'AppSettingsState',
            'paymentTypes',
          ),
          homeContentVersion: homeContentVersion,
          appFlavor: appFlavor,
          appTheme: appTheme,
          appUseCase: appUseCase,
          appEnvironment: appEnvironment,
          appIntegrityCheck: appIntegrityCheck,
          sslFingerPrint: sslFingerPrint,
          loyaltySettings: loyaltySettings,
          appVersion: appVersion,
          buildNumber: buildNumber,
          appName: appName,
          packageName: packageName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
