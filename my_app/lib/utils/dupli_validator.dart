bool hasNoDuplicatesBy<T>(
  List<T> list,
  String Function(T) key,
) {
  final seen = <String>{};

  for (final item in list) {
    final k = key(item);
    if (!seen.add(k)) return false;
  }

  return true;
}