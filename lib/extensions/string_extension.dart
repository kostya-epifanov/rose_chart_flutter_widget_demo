extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get upper {
    if (isEmpty) return this;
    return toUpperCase();
  }

  String get lowerAndRemoveSpace {
    if (isEmpty) return this;
    return toLowerCase().replaceAll(' ', '');
  }
}

extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  String getValueOrElse(String orElse) => isNullOrEmpty ? orElse : this!;
}

T enumFromString<T>(
  Iterable<T> values,
  String value, {
  T Function()? orElse,
}) {
  return values.firstWhere((type) => type.toString().split('.').last == value, orElse: orElse);
}
