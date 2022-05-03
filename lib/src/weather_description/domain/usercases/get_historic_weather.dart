import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/domain/repositories/weather_repository.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

abstract class GetHistoricWeather {
  Future<Either<Failure, List<WeatherEntity>>> call(LatLon latLon);
}

@Injectable(singleton: false)
class GetHistoricWeatherImpl implements GetHistoricWeather {
  final WeatherRepository weatherRepository;

  GetHistoricWeatherImpl(this.weatherRepository);
  @override
  Future<Either<Failure, List<WeatherEntity>>> call(LatLon? latLon) async {
    var option = optionOf(latLon);
    return option.fold(() => Left(InvalidLatLon()), (latLon) async {
      var result =
          await weatherRepository.getHistoricWeatherFromLocation(latLon);

      return result.where((r) => r.isNotEmpty, () => Failure());
    });
  }
}