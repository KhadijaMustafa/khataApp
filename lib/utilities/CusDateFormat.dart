import 'package:intl/intl.dart';

class CusDateFormat {
  static getDate(DateTime date) => DateFormat('y - MM - dd').format(date);
}
