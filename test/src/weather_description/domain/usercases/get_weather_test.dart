import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/domain/repositories/weather_repository.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercases/get_instant_weather.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

import 'get_weather_test.mocks.dart';

@GenerateMocks([WeatherRepository])
main() {
  final repository = MockWeatherRepository();
  final usecase = GetInstantWeatherImpl(repository);
  LatLon validLatLon = LatLon(latitude: "-23.533773", longitude: "-46.625290");
  LatLon invalidLatLon = LatLon(latitude: "", longitude: "");

  WeatherEntity weatherEntity =
      WeatherEntity(weather: "", temp: "", tempMin: "", tempMax: "",date: DateTime.parse("0000-00-00 00:00:00"));

  test('Deve retornar um WeatherEntity com resultados', () async {
    when(repository.getInstantWeatherFromLocation(validLatLon))
        .thenAnswer((_) async => right(weatherEntity));

    var result = await usecase(validLatLon);
    expect(result.fold(id, id), isA<WeatherEntity>());
  });

  test(
      'Deve retornar um InvalidLatLon caso a latitude e logitude seja nulo',
      () async {
    var result = await usecase(null);
    expect(result.fold(id, id), isA<InvalidLatLon>());
  });

  test(
      'Deve retornar um InvalidLatLon caso a latitude e logitude seja inválida',
      () async {
    when(repository.getInstantWeatherFromLocation(invalidLatLon))
        .thenAnswer((_) async => left(InvalidLatLon()));
    var result = await usecase(null);
    expect(result.fold(id, id), isA<InvalidLatLon>());
  });
}
