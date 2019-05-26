import 'package:weather_sc/models/day_forecast.dart';

class WeatherForecast {
  final int _cityId;
  final _dayForecast = <DayForecast>[];

  WeatherForecast(this._cityId);

  List<DayForecast> get dayForecast => _dayForecast;

  int get cityId => _cityId;

  void add(DateTime date, List forecastData) {
    final dayForecast = DayForecast(date, forecastData);
    _dayForecast.add(dayForecast);
  }
}
