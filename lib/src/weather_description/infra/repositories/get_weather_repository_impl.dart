import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/repositories/weather_repository.dart';
import 'package:ride_the_weather/src/weather_description/infra/datasources/get_weather_datasource.dart';
import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

@Injectable(singleton: false)
class WeatherRepositoryImpl implements WeatherRepository {
  final GetWeatherDatasource datasource;

  WeatherRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, WeatherEntity>> getInstantWeatherFromLocation(
    LatLon latlon,
  ) async {
    WeatherModel? weatherModel;

    try {
      weatherModel = await datasource.getInstantWeather(latlon);
    } catch (e) {
      return left(Failure());
    }

    return weatherModel == null ? left(Failure()) : right(weatherModel);
  }

  @override
  Future<Either<Failure, List<WeatherEntity>>> getHistoricWeatherFromLocation(
      LatLon latlon) async {
    List<WeatherEntity> list;

    try {
      list = await datasource.getHistoricWeather(latlon);
    } catch (e) {
      return left(Failure());
    }

    return list == null ? left(Failure()) : right(list);
  }
}
