extension CapExtension on String {
  String get capitalize => '${this[0].toUpperCase()}${substring(1)}';
  String get threeDigitsFormatter => length < 2
      ? '00$this'
      : length < 3
          ? '0$this'
          : this;
}
