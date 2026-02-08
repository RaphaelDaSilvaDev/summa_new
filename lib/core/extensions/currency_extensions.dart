import 'package:intl/intl.dart';

extension IntFormat on int {
  String formatCurrencyBR() {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final value = this / 100.0;
    return formatter.format(value);
  }
}

extension StringFormat on String {
  int parseCurrencyBRToCents() {
    final cleaned = replaceAll(
      'R\$',
      '',
    ).replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '').trim();

    final doubleValue = double.tryParse(cleaned);
    if (doubleValue == null) return 0;

    return (doubleValue).round();
  }
}
