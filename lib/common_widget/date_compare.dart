import 'package:intl/intl.dart';

String getDateDifferenceMessage(String dateString) {
  try {
    // Define the date format
    DateFormat format = DateFormat("dd/MM/yyyy");

    // Parse the stored date string into a DateTime object
    DateTime storedDate = format.parse(dateString);

    // Get the current system date (without time)
    DateTime currentDate = DateTime.now();
    currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    // Calculate the difference in days
    int daysDifference = storedDate.difference(currentDate).inDays;

    if (daysDifference > 3) {
      return "This item is still fresh";
    } else if (daysDifference == 3) {
      return "This item expires in 3 days";
    } else if (daysDifference == 2) {
      return "This item expires in 2 days";
    } else if (daysDifference == 1) {
      return "This item expires in 1 day";
    } else if (daysDifference == 0) {
      return "This item expires today";
    } else {
      return "This item expired ${-daysDifference} days ago";
    }
  } catch (e) {
    return "Invalid date format!";
  }
}

int getDateDifferenceNumber(String dateString) {
  try {
    DateFormat format = DateFormat("dd/MM/yyyy");

    DateTime storedDate = format.parse(dateString);

    DateTime currentDate = DateTime.now();
    currentDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );

    int daysDifference = storedDate.difference(currentDate).inDays;

    return daysDifference < 0 ? 0 : daysDifference;
  } catch (e) {
    return 404;
  }
}
