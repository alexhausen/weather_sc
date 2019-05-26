import 'package:weather_sc/models/speed.dart';
import 'package:weather_sc/models/temperature.dart';
import 'package:weather_sc/models/weather_phenomenon.dart';
import 'package:weather_sc/models/wind.dart';

enum DayPart { fullDay, dawn, morning, afternoon, evening }

class DayPartForecast {
  DayPart _dayPart;
  int _iconId;
  Temperature _max;
  Temperature _min;
  Wind _wind;
  int _moisture;
  int _rain;
  String _description;
  WeatherPhenomenon _event;

  DayPartForecast(Map dayPartData) {
    // _dateRefresh = dayPartData['dtAtualizacao'];
    // _dateForecast = dayPartData['dtPrev'];
    // _dateElab = dayPartData['dtElab'];
    _iconId = dayPartData['iconPrev'];
    _dayPart = DayPart.values[dayPartData['periodoDia']];
    _rain = dayPartData['mmChuva'];
    _moisture = dayPartData['umidadeRel'];
    _wind = Wind(
      Speed(dayPartData['velVentoMax']),
      Speed(dayPartData['velVentoMed']),
      dayPartData['dirVentoIni'],
      dayPartData['dirVentoFin'],
    );
    if (dayPartData['tempMin'] != null)
      _min = Temperature(dayPartData['tempMin']);
    if (dayPartData['tempMax'] != null)
      _max = Temperature(dayPartData['tempMax']);
    _description = dayPartData['nmCondicao'];
    int eventIconId = dayPartData['iconFenomeno1'];
    String eventDescription = dayPartData['iconFenomeno1Desc'];
    _event = WeatherPhenomenon(eventIconId, eventDescription);
  }

  DayPart get dayPart => _dayPart;

  Temperature get max => _max;

  Temperature get min => _min;

  int get iconId => _iconId;

  int get moisture => _moisture;

  int get rain => _rain;

  Wind get wind => _wind;

  String get description => _description;

  WeatherPhenomenon get event => _event;

  String get dayPartDescription {
    String description;
    switch (_dayPart) {
      case DayPart.fullDay:
        description = 'Full day';
        break;
      case DayPart.dawn:
        description = 'Dawn';
        break;
      case DayPart.morning:
        description = 'Morning';
        break;
      case DayPart.afternoon:
        description = 'Afternoon';
        break;
      case DayPart.evening:
        description = 'Evening';
        break;
    }
    return description;
  }
}

