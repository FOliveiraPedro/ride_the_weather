import 'dart:convert';

import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';

class WeatherModel extends WeatherEntity {
  WeatherModel(
      {required String weather,
      required String temp,
      required String tempMin,
      required String tempMax,
      required DateTime date,
      })
      : super(weather: weather, temp: temp, tempMin: tempMin, tempMax: tempMax,date: date);

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'weather': weather});
    result.addAll({'temp': temp});
    result.addAll({'tempMin': tempMin});
    result.addAll({'tempMax': tempMax});

    return result;
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory WeatherModel.fromJson(Map<String, dynamic> map) {
    return WeatherModel(
      weather: map['weather'][0]['main'] ?? '',
      temp: map['main']['temp'] != null? map['main']['temp'].toString(): '',
      tempMin: map['main']['temp_min'] != null? map['main']['temp_min'].toString() : '',
      tempMax: map['main']['temp_max'] != null? map['main']['temp_max'].toString() : '',
      date: map['dt_txt'] != null? DateTime.parse(map['dt_txt']) : DateTime.parse("0000-00-00 00:00:00"),
    );
  }
}
