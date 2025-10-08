import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saver_bbk_main/l10n/app_localizations.dart';

String getDateDifferenceMessage(String dateString, BuildContext context) {
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

    if (daysDifference > 3) {
      return AppLocalizations.of(context)!.thisItemIsStillFresh;
    } else if (daysDifference == 3) {
      return AppLocalizations.of(context)!.thisItemExpiresInThreeDay;
    } else if (daysDifference == 2) {
      return AppLocalizations.of(context)!.thisItemExpiresInTwoDay;
    } else if (daysDifference == 1) {
      return AppLocalizations.of(context)!.thisItemExpiresInOneDay;
    } else if (daysDifference == 0) {
      return AppLocalizations.of(context)!.thisItemExpiresToday;
    } else {
      return "${AppLocalizations.of(context)!.thisItemExpired} ${-daysDifference} ${AppLocalizations.of(context)!.daysAgo}";
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

    return daysDifference;
  } catch (e) {
    return 404;
  }
}
