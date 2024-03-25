extension StringValidators on String {
  bool isValidDateFormat() {
    final dateFormat = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return dateFormat.hasMatch(this);
  }

  bool isValidDescription() {
    return length > 5;
  }
}