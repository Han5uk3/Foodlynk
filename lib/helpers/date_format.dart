import 'package:intl/intl.dart' as intl;

class DateFormatHelper {
  static String ddmmyyyy(DateTime date) {
    return intl.DateFormat('dd-MM-yyyy').format(date);
  }
}