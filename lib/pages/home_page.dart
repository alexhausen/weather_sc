import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_sc/models/cities.dart';
import 'package:weather_sc/pages/edit_page.dart';
import 'package:weather_sc/pages/forecast_page.dart';

class HomePage extends StatefulWidget {
  final appName;

  HomePage(this.appName);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const citiesPreferencesKey = 'cities';

  @override
  void initState() {
    loadCities();
    loadPreferences();
    super.initState();
  }

  List<String> _selectedCities = [];

  void loadCities() {
    Cities.load();
    setState(() => debugPrint('json loaded'));
  }

  void loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(citiesPreferencesKey)) {
      await prefs.setStringList(citiesPreferencesKey, [
        'Florianópolis',
        'Lages',
      ]);
    }
    _selectedCities = prefs.getStringList(citiesPreferencesKey);
    setState(() => debugPrint('prefs loaded'));
  }

  void savePreferences() {
    // save currently selected cities
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setStringList(citiesPreferencesKey, _selectedCities));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(title: Text(widget.appName)),
      body: _buildForecastPages(),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(''),
          ),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Cities'),
              onTap: () => _navEdit(context)),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          Divider(),
          AboutListTile(
            icon: Icon(Icons.info),
            applicationName: widget.appName,
            aboutBoxChildren: <Widget>[
              Center(child: Text('Data source: CIRAM')),
              Center(child: Text('www.ciram.epagri.sc.gov.br')),
              Center(child: Text('Source code: github')),
            ],
          ),
        ],
      ),
    );
  }

  _buildForecastPages() {
    if (_selectedCities.isEmpty) {
      return Container(child: Text('Use "Edit" menu to add a city'));
    }
    return PageView.builder(
      itemCount: _selectedCities.length,
      itemBuilder: (context, index) {
        final name = _selectedCities[index];
        final id = Cities.loaded ? Cities.id(name) : 'null';
        return ForecastPage(name, id);
      },
    );
  }

  void _navEdit(BuildContext context) {
    final route = MaterialPageRoute(
        builder: (context) => EditPage(_selectedCities, savePreferences));
    Navigator.of(context).push(route).then((_) {
      //pop drawer
      Navigator.pop(context);
    });
  }
}
