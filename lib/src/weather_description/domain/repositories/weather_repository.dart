import 'package:dartz/dartz.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getInstantWeatherFromLocation(LatLon latlon);
  Future<Either<Failure, List<WeatherEntity>>> getHistoricWeatherFromLocation(LatLon latlon);

}
