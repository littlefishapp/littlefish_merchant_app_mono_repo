class SetUserPreference {
  String key;
  dynamic value;

  SetUserPreference(this.key, this.value);
}

class RemoveUserPreference {
  String key;

  RemoveUserPreference(this.key);
}
