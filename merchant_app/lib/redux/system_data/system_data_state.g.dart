// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_data_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SystemDataState extends SystemDataState {
  @override
  final bool? isLoading;
  @override
  final bool? hasError;
  @override
  final String? errorMessage;
  @override
  final List<StoreSubtype>? storeSubtypes;
  @override
  final List<SystemVariant>? variants;
  @override
  final List<List<StoreAttribute>>? storeAttributes;
  @override
  final List<StoreAttributeGroup>? storeAttributeGroups;
  @override
  final List<StoreProductType>? storeProductTypes;
  @override
  final List<StoreAttributeGroupLink>? storeAttributeGroupLinks;
  @override
  final List<StoreType>? storeTypes;

  factory _$SystemDataState([void Function(SystemDataStateBuilder)? updates]) =>
      (SystemDataStateBuilder()..update(updates))._build();

  _$SystemDataState._({
    this.isLoading,
    this.hasError,
    this.errorMessage,
    this.storeSubtypes,
    this.variants,
    this.storeAttributes,
    this.storeAttributeGroups,
    this.storeProductTypes,
    this.storeAttributeGroupLinks,
    this.storeTypes,
  }) : super._();
  @override
  SystemDataState rebuild(void Function(SystemDataStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SystemDataStateBuilder toBuilder() => SystemDataStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SystemDataState &&
        isLoading == other.isLoading &&
        hasError == other.hasError &&
        errorMessage == other.errorMessage &&
        storeSubtypes == other.storeSubtypes &&
        variants == other.variants &&
        storeAttributes == other.storeAttributes &&
        storeAttributeGroups == other.storeAttributeGroups &&
        storeProductTypes == other.storeProductTypes &&
        storeAttributeGroupLinks == other.storeAttributeGroupLinks &&
        storeTypes == other.storeTypes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, hasError.hashCode);
    _$hash = $jc(_$hash, errorMessage.hashCode);
    _$hash = $jc(_$hash, storeSubtypes.hashCode);
    _$hash = $jc(_$hash, variants.hashCode);
    _$hash = $jc(_$hash, storeAttributes.hashCode);
    _$hash = $jc(_$hash, storeAttributeGroups.hashCode);
    _$hash = $jc(_$hash, storeProductTypes.hashCode);
    _$hash = $jc(_$hash, storeAttributeGroupLinks.hashCode);
    _$hash = $jc(_$hash, storeTypes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SystemDataState')
          ..add('isLoading', isLoading)
          ..add('hasError', hasError)
          ..add('errorMessage', errorMessage)
          ..add('storeSubtypes', storeSubtypes)
          ..add('variants', variants)
          ..add('storeAttributes', storeAttributes)
          ..add('storeAttributeGroups', storeAttributeGroups)
          ..add('storeProductTypes', storeProductTypes)
          ..add('storeAttributeGroupLinks', storeAttributeGroupLinks)
          ..add('storeTypes', storeTypes))
        .toString();
  }
}

class SystemDataStateBuilder
    implements Builder<SystemDataState, SystemDataStateBuilder> {
  _$SystemDataState? _$v;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  bool? _hasError;
  bool? get hasError => _$this._hasError;
  set hasError(bool? hasError) => _$this._hasError = hasError;

  String? _errorMessage;
  String? get errorMessage => _$this._errorMessage;
  set errorMessage(String? errorMessage) => _$this._errorMessage = errorMessage;

  List<StoreSubtype>? _storeSubtypes;
  List<StoreSubtype>? get storeSubtypes => _$this._storeSubtypes;
  set storeSubtypes(List<StoreSubtype>? storeSubtypes) =>
      _$this._storeSubtypes = storeSubtypes;

  List<SystemVariant>? _variants;
  List<SystemVariant>? get variants => _$this._variants;
  set variants(List<SystemVariant>? variants) => _$this._variants = variants;

  List<List<StoreAttribute>>? _storeAttributes;
  List<List<StoreAttribute>>? get storeAttributes => _$this._storeAttributes;
  set storeAttributes(List<List<StoreAttribute>>? storeAttributes) =>
      _$this._storeAttributes = storeAttributes;

  List<StoreAttributeGroup>? _storeAttributeGroups;
  List<StoreAttributeGroup>? get storeAttributeGroups =>
      _$this._storeAttributeGroups;
  set storeAttributeGroups(List<StoreAttributeGroup>? storeAttributeGroups) =>
      _$this._storeAttributeGroups = storeAttributeGroups;

  List<StoreProductType>? _storeProductTypes;
  List<StoreProductType>? get storeProductTypes => _$this._storeProductTypes;
  set storeProductTypes(List<StoreProductType>? storeProductTypes) =>
      _$this._storeProductTypes = storeProductTypes;

  List<StoreAttributeGroupLink>? _storeAttributeGroupLinks;
  List<StoreAttributeGroupLink>? get storeAttributeGroupLinks =>
      _$this._storeAttributeGroupLinks;
  set storeAttributeGroupLinks(
    List<StoreAttributeGroupLink>? storeAttributeGroupLinks,
  ) => _$this._storeAttributeGroupLinks = storeAttributeGroupLinks;

  List<StoreType>? _storeTypes;
  List<StoreType>? get storeTypes => _$this._storeTypes;
  set storeTypes(List<StoreType>? storeTypes) =>
      _$this._storeTypes = storeTypes;

  SystemDataStateBuilder();

  SystemDataStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _isLoading = $v.isLoading;
      _hasError = $v.hasError;
      _errorMessage = $v.errorMessage;
      _storeSubtypes = $v.storeSubtypes;
      _variants = $v.variants;
      _storeAttributes = $v.storeAttributes;
      _storeAttributeGroups = $v.storeAttributeGroups;
      _storeProductTypes = $v.storeProductTypes;
      _storeAttributeGroupLinks = $v.storeAttributeGroupLinks;
      _storeTypes = $v.storeTypes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SystemDataState other) {
    _$v = other as _$SystemDataState;
  }

  @override
  void update(void Function(SystemDataStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SystemDataState build() => _build();

  _$SystemDataState _build() {
    final _$result =
        _$v ??
        _$SystemDataState._(
          isLoading: isLoading,
          hasError: hasError,
          errorMessage: errorMessage,
          storeSubtypes: storeSubtypes,
          variants: variants,
          storeAttributes: storeAttributes,
          storeAttributeGroups: storeAttributeGroups,
          storeProductTypes: storeProductTypes,
          storeAttributeGroupLinks: storeAttributeGroupLinks,
          storeTypes: storeTypes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
