import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension DateTimeFormatX on DateTime {
  String toDdMMyyyyHm() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }
}
