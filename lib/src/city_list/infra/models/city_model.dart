import 'dart:convert';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

class CityModel extends CityEntity {
  CityModel(
      {required String cityName,
      required String country,
      required LatLon latLon})
      : super(name: cityName, country: country, latLon: latLon);

  factory CityModel.fromJson(Map<String, dynamic> map) {
    return CityModel(
      cityName: map['name'] ?? '',
      country: map['country'] ?? '',
      latLon:
          LatLon(latitude: map['lat'].toString(), longitude: map['lon'].toString()),
    );
  }
}
