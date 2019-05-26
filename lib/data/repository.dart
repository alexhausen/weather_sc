import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:weather_sc/transactions/fetch_data.dart';
import 'package:weather_sc/models/weather_forecast.dart';
import 'package:weather_sc/data/database.dart';
import 'package:weather_sc/data/date_helper.dart' as DateHelper;
// import 'package:flutter/material.dart';

class Repository {
  static final Repository _self = Repository._internal();

  static Repository get instance => _self;

  Repository._internal();

  String _getUrl(int cityId, DateTime date) {
    final formattedDate = DateHelper.dateFormat(date);
    final url = 'http://ciram.epagri.sc.gov.br/wsprev/resources/listaJson/'
        'prevMuni?cdCidade=$cityId&data=$formattedDate';
    return url;
  }

  List<dynamic> _toJson(String jsonString) {
    return json.decode(utf8.decode(jsonString.codeUnits));
  }

  _tooOld(int dtUpdate) {
    final now = DateTime.now();
    final updateTime = DateTime.fromMillisecondsSinceEpoch(dtUpdate);
    final diff = now.difference(updateTime).inHours;
    return diff > 1;
  }

  Future<String> _fetchAndUpdateDB(int cityId, DateTime day) async {
    final url = _getUrl(cityId, day);
    debugPrint('_fetchAndUpdateDB: $url');
    final jsonString = await fetchData(url);
    // debugPrint(jsonString);
    final wfdb = WeatherForecastDatabase.instance;
    wfdb.updateWeatherForecast(cityId, day, jsonString);
    return jsonString;
  }

  Future<WeatherForecast> getWeatherForecast(int cityId,
      [bool force = false]) async {
    final wf = WeatherForecast(cityId);
    const oneDay = Duration(days: 1);
    const nDays = 5;
    var day = DateTime.now();
    final wfdb = WeatherForecastDatabase.instance;
    for (int i = 0; i < nDays; i++) {
      List data;
      if (!force) data = await wfdb.getWeatherForecast(cityId, day);
      // try {
      String jsonString;
      if (data == null) {
        jsonString = await _fetchAndUpdateDB(cityId, day);
      } else {
        jsonString = data[0];
        final int dtUpdate = data[1];
        if (_tooOld(dtUpdate)) {
          jsonString = await _fetchAndUpdateDB(cityId, day);
        }
      }
      wf.add(day, _toJson(jsonString));
      day = day.add(oneDay);
      // } catch (e) {
      //   debugPrint(e.toString());
      // }
    }
    return wf;
  }
}
