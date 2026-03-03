class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({
    required this.start,
    required this.end,
  });
}

class DateRangeUtils {
  static DateTime dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  static DateRange monthRange(DateTime reference) {
    final start = DateTime(reference.year, reference.month, 1);
    final end = DateTime(reference.year, reference.month + 1, 0);
    return DateRange(start: start, end: end);
  }

  static DateRange weekRange(DateTime reference) {
    final dateOnlyRef = dateOnly(reference);
    final weekday = dateOnlyRef.weekday; // 1 = Mon, 7 = Sun
    final start = dateOnlyRef.subtract(Duration(days: weekday - 1));
    final end = start.add(const Duration(days: 6));
    return DateRange(start: start, end: end);
  }

  static List<DateTime> lastNDays(DateTime reference, int n) {
    final List<DateTime> days = [];
    final dateOnlyRef = dateOnly(reference);
    for (var i = n - 1; i >= 0; i--) {
      days.add(dateOnlyRef.subtract(Duration(days: i)));
    }
    return days;
  }
}

