import 'dart:convert';

class WeatherEntity {
  String weather;
  String temp;
  String tempMin;
  String tempMax;
  DateTime date;

  WeatherEntity({
    required this.weather,
    required this.temp,
    required this.tempMin,
    required this.tempMax,
    required this.date,
  });
}
