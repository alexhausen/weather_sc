import 'package:flutter/material.dart';

import 'package:weather_sc/data/repository.dart';
import 'package:weather_sc/models/weather_forecast.dart';
import 'package:weather_sc/models/day_forecast.dart';
import 'package:weather_sc/models/day_part_forecast.dart';

class ForecastPage extends StatefulWidget {
  final String _cityName;
  final int _cityId;

  ForecastPage(this._cityName, this._cityId);

  @override
  State<StatefulWidget> createState() => _ForecastPage();
}

class _ForecastPage extends State<ForecastPage> {
  Future _weatherForecast;

  @override
  void initState() {
    _weatherForecast = Repository.instance.getWeatherForecast(widget._cityId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherForecast,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container(
              child: Text('none'),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
              //Text('waiting'),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            final data = snapshot.data;
            return _buildForecast(data);
            break;
        }
      },
    );
  }

  Widget _buildForecast(WeatherForecast wf) {
    final children = <Widget>[];
    wf.dayForecast.forEach((final dayForecast) {
      children.add(_buildDayForecast(dayForecast));
    });
    return RefreshIndicator(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Center(
                child: Text(
              widget._cityName,
              style: Theme.of(context).textTheme.headline,
            )),
          ),
          Column(children: children),
        ],
      ),
      onRefresh: () async {
        setState(() {
          _weatherForecast =
              Repository.instance.getWeatherForecast(widget._cityId, true);
        });
      },
    );
  }

  Widget _buildDayForecast(DayForecast dayForecast) {
    final children = <Widget>[];
    children.addAll(_buildAllDayPartsForecast(dayForecast.dayParts));
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(dayForecast.formattedDate,
                style: Theme.of(context).textTheme.caption),
          ),
          Card(
            child: Column(children: children),
            color: Colors.orange[50],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAllDayPartsForecast(List<DayPartForecast> dayParts) {
    final children = <Widget>[];
    for (int i = 0; i < dayParts.length; i++) {
      final period = dayParts[i];
      Widget w = _buildDaySingleDayPartForecast(period);
      if (w != null) {
        children.add(w);
        if (i < dayParts.length - 1) {
          children.add(Divider(height: 6));
        }
      }
    }
    return children;
  }

  Widget _buildDaySingleDayPartForecast(DayPartForecast forecast) {
    if (forecast.min == null || forecast.max == null) return null;

    int eventIconId = 0;
    String eventDescription = '';
    if (forecast.event != null) {
      eventIconId = forecast.event.iconId;
      eventDescription = forecast.event.description;
    }
    final children = <Widget>[
      Container(
        alignment: Alignment.center,
        width: 68.0,
        child: Text('${forecast.dayPartDescription}'),
      ),
      Image.asset(
        'assets/icons/weather/${forecast.iconId}.png',
        width: 36.0,
        fit: BoxFit.scaleDown,
      ),
      Container(
        width: 28.0,
        child: Column(
          children: <Widget>[
            Text('${forecast.max}\u00b0'),
            Text('${forecast.min}\u00b0'),
          ],
        ),
      ),
      Container(width: 52.0, child: Text('${forecast.rain} mm')),
      Image.asset(
        'assets/icons/event/$eventIconId.png',
        width: 36.0,
        alignment: Alignment.bottomLeft,
      ),
    ];
    // remove description 'fullDay'
    if (forecast.dayPart == DayPart.fullDay) {
      children.removeAt(0);
    }

    /*
     TODO
     Add container with:
     - moisture %
     - wind direction and speed
     - period description
     - event description

    debugPrint('moisture ${forecast.moisture} %');
    debugPrint('wind ${forecast.wind.direction}');
    debugPrint('${forecast.wind.averageSpeed} km/h');
    debugPrint('${forecast.wind.topSpeed} km/h');
    debugPrint('${forecast.description}');
    debugPrint('$eventDescription');
    */

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
