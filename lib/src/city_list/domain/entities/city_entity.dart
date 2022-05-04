import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

class CityEntity {
  final String name;
  final String country;
  final LatLon latLon;

  CityEntity({required this.name, required this.country, required this.latLon});
}
