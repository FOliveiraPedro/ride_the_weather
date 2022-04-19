import 'package:dartz/dartz.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercase/get_weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeatherFromLocation(
      LatLon latlon);
}
