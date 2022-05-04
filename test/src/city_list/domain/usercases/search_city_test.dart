import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';
import 'package:ride_the_weather/src/city_list/domain/repositories/search_city_repository.dart';
import 'package:ride_the_weather/src/city_list/domain/usercase/search_city.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

import 'search_city_test.mocks.dart';

@GenerateMocks([SearchCityRepository])
main() {
  final repository = MockSearchCityRepository();
  final usecase = SearchCityImpl(repository);

  CityEntity cityEntity = CityEntity(
      name: "São Paulo",
      country: "BR",
      latLon: LatLon(latitude: "-23.533773", longitude: "-46.625290"));

  test('Deve retornar um CityEntity como resultado', () async {
    when(repository.getLocationData("São Paulo"))
        .thenAnswer((_) async => right(cityEntity));

    var result = await usecase("São Paulo");
    expect(result.fold(id, id), isA<CityEntity>());
  });

  // test('Deve retornar um InvalidLatLon caso a latitude e logitude seja nulo',
  //     () async {
  //   var result = await usecase();
  //   expect(result.fold(id, id), isA<InvalidLatLon>());
  // });

  test(
      'Deve retornar um InvalidLatLon caso a latitude e logitude seja inválida',
      () async {
    when(repository.getLocationData(""))
        .thenAnswer((_) async => left(InvalidCityName()));
    var result = await usecase("");
    expect(result.fold(id, id), isA<InvalidCityName>());
  });
}
