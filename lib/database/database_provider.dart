import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/database/database_manader.dart';
import 'package:meditation_tracker/database/database_session.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseSessionPreview get preview => this._preview;
  late DatabaseSessionPreview _preview = DatabaseSessionPreview([], '');

  final _databaseManager = DatabaseManager();

  void getAll() {
    this._getAll();
  }

  void _getAll() async {
    var values = await _databaseManager.getAll();
    values.sort();
    values = values.reversed.toList();

    final sessionsByMonths = _sortSessionByMonth(values);
    final totalTime = _getTotalTime(values);
    final sessionsPreview = DatabaseSessionPreview(sessionsByMonths, totalTime);
    _preview = sessionsPreview;
    notifyListeners();
  }

  List<DatabaseSessionByMonth> _sortSessionByMonth(
      List<DatabaseSession> values) {
    // Sessions By Days
    final daysList = values.map((e) {
      return DateFormat.yMMMEd().parse(DateFormat.yMMMEd().format(e.date));
    }).toSet();

    final sessionsByDays = daysList.map((dateDay) {
      List<DatabaseSession> sessionsByDay = values
          .where((el) => (el.date.month == dateDay.month &&
              el.date.year == dateDay.year &&
              el.date.day == dateDay.day))
          .toList();
      return DatabaseSessionByDay(dateDay, sessionsByDay);
    }).toList();

    // Sessions By Months
    final monthList = sessionsByDays.map((e) {
      return DateFormat.yMMMM().parse(DateFormat.yMMMM().format(e.date));
    }).toSet();

    final sessionByMonths = monthList.map((dateMonth) {
      List<DatabaseSessionByDay> sessionsByMonth = sessionsByDays
          .where((el) => (el.date.month == dateMonth.month &&
              el.date.year == dateMonth.year))
          .toList();
      return DatabaseSessionByMonth(dateMonth, sessionsByMonth);
    }).toList();

    return sessionByMonths;
  }

  String _getTotalTime(List<DatabaseSession> values) {
    if (values.isNotEmpty) {
      final durationMins = values
          .map<int>((el) => el.durationMins)
          .reduce((value, element) => value + element);

      final countHours = durationMins ~/ 60;
      final countMins = countHours == 0 ? durationMins : (durationMins % 60);

      final String hours = countHours == 0 ? '' : '${countHours}h';
      final String mins = countMins == 0 ? '' : '${countMins}m';

      return '$hours $mins';
    }
    return '';
  }

  void insert(DatabaseSession session) {
    _databaseManager.insert(session).then((_) => this.getAll());
  }

  void delete(DatabaseSession session) {
    _databaseManager.delete(session).then((_) => this.getAll());
  }

  void update(DatabaseSession session) {
    _databaseManager.update(session).then((_) => this.getAll());
  }

  void deleteAll() {
    _databaseManager.deleteAll().then((_) => this.getAll());
  }
}
