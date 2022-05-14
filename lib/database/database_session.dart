import 'package:meditation_tracker/common/date_formatter.dart';

class DatabaseSessionPreview {
  final String totalTime;
  final List<DatabaseSessionByMonth> months;

  DatabaseSessionPreview(this.months, this.totalTime);
}

class DatabaseSessionByMonth {
  final DateTime date;
  final List<DatabaseSessionByDay> days;

  DatabaseSessionByMonth(this.date, this.days);
}

class DatabaseSessionByDay {
  final DateTime date;
  final List<DatabaseSession> sessions;

  DatabaseSessionByDay(this.date, this.sessions);
}

class DatabaseSession implements Comparable<DatabaseSession> {
  int? id;
  final String dateString;
  final int durationMins;
  DateTime get date {
    return defaultDateFormatter.parse(this.dateString);
  }

  DatabaseSession(
      {this.id = null, required this.dateString, required this.durationMins});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'dateString': dateString,
      'durationMins': durationMins,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory DatabaseSession.fromMap(Map<dynamic, dynamic> map) {
    return DatabaseSession(
        id: map['id'],
        dateString: map['dateString'],
        durationMins: map['durationMins']);
  }

  @override
  bool operator ==(Object other) {
    if (other is! DatabaseSession) return false;
    if (dateString != other.dateString) return false;
    if (durationMins != other.durationMins) return false;
    return true;
  }

  @override
  int compareTo(DatabaseSession other) {
    return this.date.compareTo(other.date);
  }
}
