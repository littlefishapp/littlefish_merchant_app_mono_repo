import 'package:equatable/equatable.dart';

class DeleteAccountInfoEntity extends Equatable {
  final bool deleteAccountAllowed;
  final bool deleteAccountActionVisible;

  const DeleteAccountInfoEntity({
    this.deleteAccountAllowed = false,
    this.deleteAccountActionVisible = false,
  });

  @override
  List<Object?> get props => [deleteAccountAllowed, deleteAccountActionVisible];

  DeleteAccountInfoEntity copyWith({
    bool? deleteAccountAllowed,
    bool? deleteAccountActionVisible,
  }) {
    return DeleteAccountInfoEntity(
      deleteAccountAllowed: deleteAccountAllowed ?? this.deleteAccountAllowed,
      deleteAccountActionVisible:
          deleteAccountActionVisible ?? this.deleteAccountActionVisible,
    );
  }
}
