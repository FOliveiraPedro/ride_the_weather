import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/infra/datasources/get_weather_datasource.dart';
import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/infra/repositories/get_weather_repository_impl.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

import 'get_weather_repository_test.mocks.dart';

@GenerateMocks([GetWeatherDatasource])
main() {
  final datasource = MockGetWeatherDatasource();
  final repository = WeatherRepositoryImpl(datasource);
  LatLon validLatLon = LatLon(latitude: "-23.533773", longitude: "-46.625290");
  LatLon invalidLatLon = LatLon(latitude: "", longitude: "");
  WeatherModel weatherModel =
      WeatherModel(weather: "", temp: "", tempMin: "", tempMax: "", date:  DateTime.parse(""));
  test('deve retornar um WeatherEntity', () async {
    when(datasource.getInstantWeather(validLatLon))
        .thenAnswer((_) async => weatherModel);
    var result = await repository.getInstantWeatherFromLocation(validLatLon);
    expect(result.fold(id, id), isA<WeatherEntity>());
  });

  test('deve retornar uma Failure caso seja lançado throw no datasource',
      () async {
    when(datasource.getInstantWeather(invalidLatLon)).thenAnswer((_) async => null);

    var result = await repository.getInstantWeatherFromLocation(invalidLatLon);
    expect(result.fold(id, id), isA<Failure>());
  });
}
