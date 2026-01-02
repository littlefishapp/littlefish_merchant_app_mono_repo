String findClosestKey(Map<String, dynamic> layout, String keyToUse) {
  if (keyToUse.isEmpty || layout.isEmpty) {
    return '';
  }

  if (layout.containsKey(keyToUse)) {
    return keyToUse;
  }

  String bestContainedMatch = '';
  final lowerCaseKeyToUse = keyToUse.toLowerCase();

  for (final key in layout.keys) {
    final lowerCaseKey = key.toLowerCase();
    if (lowerCaseKeyToUse.contains(lowerCaseKey)) {
      if (lowerCaseKey.length > bestContainedMatch.length) {
        bestContainedMatch = key;
      }
    }
  }

  if (bestContainedMatch.isNotEmpty) {
    return bestContainedMatch;
  }

  return '';
}
