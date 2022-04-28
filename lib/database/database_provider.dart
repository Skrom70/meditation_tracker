import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditation_tracker/common/date_formatter.dart';
import 'package:meditation_tracker/database/database_manader.dart';
import 'package:meditation_tracker/database/database_session.dart';

class DatabaseProvider extends ChangeNotifier {
  List<DatabaseSession> _sessions = [
    // DatabaseSession(
    //     id: 0, durationMins: 25, dateString: 'April 17, 2022 17:31'),
    // DatabaseSession(
    //     id: 0, durationMins: 25, dateString: 'April 21, 2022 17:31'),
    // DatabaseSession(id: 0, durationMins: 25, dateString: 'April 7, 2022 17:32'),
    // DatabaseSession(id: 0, durationMins: 25, dateString: 'April 1, 2022 17:32'),
    // DatabaseSession(id: 0, durationMins: 25, dateString: 'July 5, 2022 17:32'),
    // DatabaseSession(id: 0, durationMins: 25, dateString: 'July 3, 2022 17:32'),
    // DatabaseSession(id: 0, durationMins: 25, dateString: 'July 17, 2021 17:32'),
    // DatabaseSession(
    //     id: 0, durationMins: 25, dateString: 'April 17, 2022 17:32'),
  ];
  List<DatabaseSession> get sessions => this._sessions;

  Map<DateTime, List<DatabaseSession>> _sessionsByMonth = {};
  Map<DateTime, List<DatabaseSession>> get sessionsByMonth =>
      this._sessionsByMonth;

  final _databaseManager = DatabaseManager();

  String get totalTime => _totalTime;
  String _totalTime = '';

  void getAll() {
    this._getAll();
  }

  void _getAll() async {
    _databaseManager.getAll().then((value) {
      value.sort();
      _sessions = value;
      _sessions.sort();
      _sessions = _sessions.reversed.toList();
      this._getByMonth();
      this._getTotalTime();
      notifyListeners();
    });
  }

  void _getByMonth() {
    final monthsList = sessions.map((e) {
      return DateFormat.yMMMM().parse(DateFormat.yMMMM().format(e.date));
    }).toSet();

    final Map<DateTime, List<DatabaseSession>> sessionByMonth = {};

    monthsList.forEach((dateMonth) {
      sessionByMonth[dateMonth] = sessions
          .where((el) => (el.date.month == dateMonth.month &&
              el.date.year == dateMonth.year))
          .toList();
    });

    _sessionsByMonth = sessionByMonth;
  }

  void _getTotalTime() {
    final durationMins = sessions
        .map<int>((el) => el.durationMins)
        .reduce((value, element) => value + element);

    final countHours = durationMins ~/ 60;
    final countMins = countHours == 0 ? durationMins : (durationMins % 60);

    final String hours = countHours == 0 ? '' : '${countHours}h';
    final String mins = countMins == 0 ? '' : '${countMins}m';

    _totalTime = '$hours $mins';
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
