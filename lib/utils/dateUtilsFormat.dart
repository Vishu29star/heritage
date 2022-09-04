import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  static final _formatBirthDate = DateFormat('dd/MM/yyyy');
  static final _formatBirthDateForServer = DateFormat('yyyy-MM-dd');
  static final _formatOverviewBirthDate = DateFormat('dd, MMM yyyy');
  static final _formatDateTime = DateFormat('yyyy-MM-dd hh:mm:ss');
  static final _formatTime = DateFormat('hh:mma');
  static final _formatJobDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static final _formatDisplayDate = DateFormat('MMM dd, yyyy');
  static final _formatDisplayJobDate = DateFormat('dd/MM/yyyy');

  static String formatBirthDate(DateTime? date) {
    if (date == null) return '';
    return _formatBirthDate.format(date);
  }
  static DateTime formatToDate(String ? date) {
    if (date == null) return DateTime.now();
    return _formatBirthDate.parse(date);
  }

  static String formatBirthDateForServer(DateTime? date) {
    if (date == null) return '';
    return Intl.withLocale('en', () => _formatBirthDateForServer.format(date));
  }

  static DateTime? parseBirthDateFromServer(String? dateOfBirth) {
    if (dateOfBirth == null) return null;
    return Intl.withLocale('en', () => _formatBirthDate.parse(dateOfBirth));
  }

  static String formatBirthDateFromServer(String? dateOfBirth) {
    if (dateOfBirth == null) return '';
    final dateTime =
    Intl.withLocale('en', () => _formatBirthDate.parse(dateOfBirth));
    return _formatOverviewBirthDate.format(dateTime);
  }

  static String? formatBirthDateUserToServer(String? dateOfBirth) {
    if (dateOfBirth == null) return null;
    final dateTime =
    Intl.withLocale('en', () => _formatBirthDate.parse(dateOfBirth));
    return _formatBirthDateForServer.format(dateTime);
  }

  static String formatDisplayDate(DateTime? date) {
    if (date == null) return '';
    return _formatDisplayDate.format(date);
  }

  static String formatCreateDate(String? date) {
    if (date == null) return '';
    final dateTime = Intl.withLocale('en', () => _formatDateTime.parse(date));
    return _formatDisplayDate.format(dateTime);
  }

  static String jobCreateDate(String? date) {
    if (date == null) return '';

    DateTime parseDate = _formatJobDateTime.parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    print("date");
    print(date);
    print(parseDate);
    print(inputDate);
    return _formatDisplayJobDate.format(inputDate);
  }

  static String jobCreateDateToTime(String? date) {
    if (date == null) return '';

    DateTime parseDate = _formatJobDateTime.parse(date);
    parseDate = parseDate.add(Duration(hours: 5, minutes: 30));
    var inputDate = DateTime.parse(parseDate.toString());
    return _formatTime.format(inputDate);
  }

  static String calculateDifference(String? dateTimeString) {
    // if (date == null) return '';
    var currentTime = DateTime.now();
    var diff = DateTime.now().difference(DateTime.parse(dateTimeString!));
    return diff.inHours.toString();
  }
}
