import 'package:intl/intl.dart';

extension DoubleFormat on double {
  String formatQuantity() {
    final formatter = NumberFormat('#.##', 'pt_BR');
    return formatter.format(this);
  }
}

extension StringFormat on String {
  double formatStringToQuanity() {
    final cleaned = replaceAll(',', '.').trim();

    final doubleValue = double.tryParse(cleaned);
    if (doubleValue == null) return 0;

    return doubleValue;
  }
}
