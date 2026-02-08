import 'package:intl/intl.dart';

extension DateExtensions on DateTime {
  String formatDate() {
    final today = DateTime.now();

    final totayDate = DateTime(today.year, today.month, today.day);
    final targetDate = DateTime(year, month, day);

    final difference = targetDate.difference(totayDate).inDays;

    switch (difference) {
      case 0:
        {
          return 'Hoje';
        }
      case 1:
        {
          return 'Amanhã';
        }
      case >= 2 && <= 6:
        {
          return 'Em $difference dias';
        }
      default:
        {
          return DateFormat('dd/MM').format(targetDate);
        }
    }
  }
}
