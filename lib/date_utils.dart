import "package:intl/intl.dart";

class Utils {
  static final DateFormat _monthFormat = new DateFormat("MMMM yyyy", "id");
  static final DateFormat _dayFormat = new DateFormat("dd");
  static final DateFormat _firstDayFormat = new DateFormat("MMM dd");
  static final DateFormat _fullDayFormat = new DateFormat("EEE MMM dd, yyyy");
  static final DateFormat _apiDayFormat = new DateFormat("yyyy-MM-dd");

  static String formatMonth(DateTime d) => _monthFormat.format(d);
  static String formatDay(DateTime d) => _dayFormat.format(d);
  static String formatFirstDay(DateTime d) => _firstDayFormat.format(d);
  static String fullDayFormat(DateTime d) => _fullDayFormat.format(d);
  static String apiDayFormat(DateTime d) => _apiDayFormat.format(d);

  static const List<String> weekdays = const [
    "SEN",
    "SEL",
    "RAB",
    "KAM",
    "JUM",
    "SAB",
    "MIN"
  ];

  /// The list of days in a given month
  static List<DateTime> daysInMonth(DateTime month) {
    var first = firstDayOfMonth(month);
    var daysBefore = first.weekday - 1;
    var firstToDisplay = first.subtract(new Duration(days: daysBefore));
    var last = lastDayOfMonth(month);

    var daysAfter = 8 - last.weekday;
    var lastToDisplay = last.add(new Duration(days: daysAfter));
    return daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  static bool isFirstDayOfMonth(DateTime day) {
    return isSameDay(firstDayOfMonth(day), day);
  }

  static bool isLastDayOfMonth(DateTime day) {
    return isSameDay(lastDayOfMonth(day), day);
  }

  static DateTime firstDayOfMonth(DateTime month) {
    return new DateTime(month.year, month.month);
  }

  static DateTime firstDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 0);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar works from Monday - Sunday
    var decreaseNum = day.weekday;
    return day.subtract(new Duration(days: decreaseNum));
  }

  static DateTime lastDayOfWeek(DateTime day) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    day = new DateTime.utc(day.year, day.month, day.day, 0);

    /// Weekday is on a 1-7 scale Monday - Sunday,
    /// This Calendar's Week starts on Monday
    var increaseNum = day.weekday;
    return day.add(new Duration(days: increaseNum));
  }

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  /// Returns a [DateTime] for each day the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> daysInRange(DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      yield i;
      i = i.add(new Duration(days: 1));
      var timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
      }
    }
  }

  /// Returns a [DateTime] for each workday the given range.
  ///
  /// [start] inclusive
  /// [end] exclusive
  static Iterable<DateTime> workdaysInRange(
      DateTime start, DateTime end) sync* {
    var i = start;
    var offset = start.timeZoneOffset;
    while (i.isBefore(end)) {
      if (i.weekday % 6 != 0 && i.weekday % 7 != 0) {
        yield i;
        i = i.add(new Duration(days: 1));
        var timeZoneDiff = i.timeZoneOffset - offset;
        if (timeZoneDiff.inSeconds != 0) {
          offset = i.timeZoneOffset;
          i = i.subtract(new Duration(seconds: timeZoneDiff.inSeconds));
        }
      } else {
        i = i.add(new Duration(days: 1));
      }
    }
  }

  /// Whether or not two times are on the same day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameWeek(DateTime a, DateTime b) {
    /// Handle Daylight Savings by setting hour to 12:00 Noon
    /// rather than the default of Midnight
    a = new DateTime.utc(a.year, a.month, a.day);
    b = new DateTime.utc(b.year, b.month, b.day);

    var diff = a.toUtc().difference(b.toUtc()).inDays;
    if (diff.abs() >= 7) {
      return false;
    }

    var min = a.isBefore(b) ? a : b;
    var max = a.isBefore(b) ? b : a;
    var result = max.weekday - min.weekday >= 0;
    return result;
  }

  static DateTime previousMonth(DateTime m) {
    var year = m.year;
    var month = m.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return new DateTime(year, month);
  }

  static DateTime nextMonth(DateTime m) {
    var year = m.year;
    var month = m.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return new DateTime(year, month);
  }

  static DateTime previousWeek(DateTime w) {
    return w.subtract(new Duration(days: 7));
  }

  static DateTime nextWeek(DateTime w) {
    return w.add(new Duration(days: 7));
  }
}
