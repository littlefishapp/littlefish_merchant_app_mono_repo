class BusinessStore {
  final String? userId;
  final String? businessId;
  final String? businessName;
  final String? role;
  final String? masterMerchantId;
  final String? description;
  final DateTime? dateCreated;

  BusinessStore({
    this.userId,
    this.businessId,
    this.businessName,
    this.role,
    this.masterMerchantId,
    this.description,
    this.dateCreated,
  });

  factory BusinessStore.fromJson(Map<String, dynamic> json) {
    return BusinessStore(
      userId: json['userId'] as String?,
      businessId: json['businessId'] as String?,
      businessName: json['businessName'] as String?,
      role: json['role'] as String?,
      masterMerchantId: json['masterMerchantId'] as String?,
      description: json['description'] as String?,
      dateCreated: json['dateCreated'] != null
          ? DateTime.tryParse(json['dateCreated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'businessId': businessId,
    'businessName': businessName,
    'role': role,
    'masterMerchantId': masterMerchantId,
    'description': description,
    'dateCreated': dateCreated?.toIso8601String(),
  };
}
