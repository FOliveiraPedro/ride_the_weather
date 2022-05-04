import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';
import 'package:ride_the_weather/src/city_list/domain/repositories/search_city_repository.dart';

abstract class SearchCity {
  Future<Either<Failure, CityEntity>> call(String cityName);
}

@Injectable(singleton: false)
class SearchCityImpl implements SearchCity {
  final SearchCityRepository searchCityRepository;

  SearchCityImpl(this.searchCityRepository);

  @override
  Future<Either<Failure, CityEntity>> call(String cityName) async {
    var option = optionOf(cityName);
    return option.fold(() => Left(InvalidCityName()), (cityName) async {
      var result = await searchCityRepository.getLocationData(cityName);

      return result.where((r) => r != null, () => Failure());
    });
  }
}
