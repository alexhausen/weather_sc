import 'package:intl/intl.dart';

import 'package:weather_sc/models/day_part_forecast.dart';

class DayForecast {
  final _dayParts = <DayPartForecast>[];
  final DateTime _date;

  DayForecast(this._date, List forecastData) {
    forecastData.forEach((dayPartData) {
      final dayPartForecast = DayPartForecast(dayPartData);
      _dayParts.add(dayPartForecast);
    });
    _dayParts.sort((p1, p2) => p1.dayPart.index.compareTo(p2.dayPart.index));
  }

  List<DayPartForecast> get dayParts => _dayParts;

  String get formattedDate {
    return DateFormat.yMEd().format(_date);
  }
}
