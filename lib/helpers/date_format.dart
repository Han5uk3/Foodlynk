import 'package:intl/intl.dart' as intl;

class DateFormatHelper {
  static String ddmmyyyy(DateTime date) {
    return intl.DateFormat('dd-MM-yyyy').format(date);
  }

  static String ddmmyyyyString(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return intl.DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return 'Invalid date format';
    }
  }
}
