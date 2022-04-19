import 'package:dartz/dartz.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/domain/repositories/weather_repository.dart';

abstract class GetWeather {
  Future<Either<Failure, WeatherEntity>> call(LatLon latLon);
}

class GetWeatherImp implements GetWeather {
  final WeatherRepository weatherRepository;

  GetWeatherImp(this.weatherRepository);
  @override
  Future<Either<Failure, WeatherEntity>> call(LatLon? latLon) async {
    var option = optionOf(latLon);
    return option.fold(() => Left(InvalidSearchText()), (latLon) async {
      var result = await weatherRepository.getWeatherFromLocation(latLon);
      return result.where((r) => r != null, () => Failure());
    });
  }
}

class LatLon {
  final String latitude;
  final String longitude;

  LatLon({required this.latitude, required this.longitude});
}
