String formatNumber(double number) {
  if (number == number.roundToDouble()) {
    return number.toInt().toString();
  } else {
    return number.toStringAsFixed(2);
  }
}