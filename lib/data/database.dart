import 'package:flutter/material.dart';

import 'dart:core';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_sc/data/date_helper.dart' as DateHelper;

class WeatherForecastDatabase {
  static final WeatherForecastDatabase _self =
      WeatherForecastDatabase._internal();

  static WeatherForecastDatabase get instance => _self;

  WeatherForecastDatabase._internal();

  Database _db;

  static final _tableName = 'ForecastTable';
  static final _cityIdField = 'cityID';
  static final _dtForecastField = 'dtForecast';
  static final _dtUpdateField = 'dtUpdate';
  static final _jsonField = 'json';

  Future<List> getWeatherForecast(int id, DateTime day) async {
    var db = await _getDb();
    final dtForecast = DateHelper.dayInMillis(day);
    var result = await db.rawQuery(
      "SELECT $_dtUpdateField, $_jsonField FROM $_tableName "
      "WHERE $_cityIdField = $id and $_dtForecastField = $dtForecast",
    );
    if (result.isEmpty) return null;
    final Map m = result[0];
    return [m['$_jsonField'], m['$_dtUpdateField']];
  }

  Future updateWeatherForecast(int id, DateTime day, String json) async {
    var db = await _getDb();
    await db.transaction((txn) async {
      final dtForecast = DateHelper.dayInMillis(day);
      final dtUpdate = DateTime.now().millisecondsSinceEpoch;
      // single quotes required for JSON field
      await txn.rawInsert(
        "INSERT OR REPLACE INTO "
        "$_tableName($_cityIdField, $_dtForecastField, $_dtUpdateField, $_jsonField) "
        "VALUES($id, $dtForecast, $dtUpdate, '$json')",
      );
    });
  }

  Future<Database> _getDb() async {
    if (_db == null) await _init();
    return _db;
  }

  Future _init() async {
    // Sqflite.devSetDebugModeOn(true);
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'wfdb.db');
    _db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE $_tableName("
        "$_cityIdField INTEGER NOT NULL,"
        "$_dtForecastField INTEGER NOT NULL,"
        "$_dtUpdateField INTEGER NOT NULL,"
        "$_jsonField TEXT NOT NULL,"
        "PRIMARY KEY($_cityIdField, $_dtForecastField))",
      );
    });
    _deleteOldData();
  }

  // House keeping
  _deleteOldData() async {
    var db = await _getDb();
    final today = DateHelper.dayInMillis(DateTime.now());
    final count = await db.rawDelete(
      'DELETE FROM $_tableName WHERE $_dtUpdateField < $today',
    );
    debugPrint("deleted = $count");
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
