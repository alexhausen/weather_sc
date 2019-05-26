import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Cities {
  static Map<String, dynamic> _cities;

  static void load() async {
    String citiesJson = await rootBundle.loadString('assets/cities.json');
    _cities = json.decode(citiesJson);
  }

  static bool get loaded => _cities != null;

  static id(String name) {
    return _cities[name];
  }

  static String name(int id) {
    if (!loaded) return null;
    final found = _cities.entries.firstWhere(
      (MapEntry<String, dynamic> e) => e.value == id,
      orElse: () => null,
    );
    return found != null ? found.key : null;
  }

  static List<String> filter(String query, List<String> names) {
    query = query.trim().toUpperCase();
    return _cities.keys
        .where((String name) =>
            name.toUpperCase().startsWith(query) && !names.contains(name))
        .toList(growable: false);
  }
}
