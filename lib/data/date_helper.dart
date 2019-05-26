import 'package:intl/intl.dart';

String dateFormat(DateTime date) {
  final formatter = DateFormat('yyyy/MM/dd');
  final formattedDate = formatter.format(date);
  return formattedDate;
}

int dayInMillis(DateTime date) {
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}
