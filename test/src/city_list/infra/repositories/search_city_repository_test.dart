import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';
import 'package:ride_the_weather/src/city_list/infra/datasources/search_city_datasource.dart';
import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';
import 'package:ride_the_weather/src/city_list/infra/repositories/search_city_repository_impl.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

import 'search_city_repository_test.mocks.dart';

@GenerateMocks([SearchCityDatasource])
main() {
  final datasource = MockSearchCityDatasource();
  final repository = SearchCityRepositoryImpl(datasource);
  LatLon validLatLon = LatLon(latitude: "-23.533773", longitude: "-46.625290");
  CityModel cityModel = CityModel(cityName: "São Paulo",country: "BR", latLon: validLatLon);

  test('deve retornar um City Entity', () async {
    when(datasource.searchCity("São Paulo"))
        .thenAnswer((_) async => cityModel);
    var result = await repository.getLocationData("São Paulo");
    expect(result.fold(id, id), isA<CityEntity>());
  });

  test('deve retornar uma Failure caso seja lançado throw no datasource',
      () async {
    when(datasource.searchCity("")).thenAnswer((_) async => null);

    var result = await repository.getLocationData("");
    expect(result.fold(id, id), isA<Failure>());
  });
}
