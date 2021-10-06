class NumberFormat {
  static formatDoubel(num number) {
    if (number == null) return 0;
    int intPart = number.toInt();
    double decimalPart = (number - intPart).toDouble();
    if (decimalPart > 0) {
      return number;
    } else {
      return intPart;
    }
  }
}
