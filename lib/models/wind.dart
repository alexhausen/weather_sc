import 'package:weather_sc/models/speed.dart';

class Wind {
  final Speed _top;
  final Speed _avg;
  final String _directionStart;
  final String _directionEnd;

  Wind(this._top, this._avg, this._directionStart, this._directionEnd);

  Speed get topSpeed => _top;

  Speed get averageSpeed => _avg;

  String get direction => '$_directionStart/$_directionEnd';
}
