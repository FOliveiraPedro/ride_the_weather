import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/repositories/search_city_repository.dart';
import 'package:ride_the_weather/src/city_list/infra/datasources/search_city_datasource.dart';
import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';

@Injectable(singleton: false)
class SearchCityRepositoryImpl implements SearchCityRepository {
  final SearchCityDatasource datasource;

  SearchCityRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, CityEntity>> getLocationData(String cityName) async {
    CityModel? cityModel;

    try {
      cityModel = await datasource.searchCity(cityName);
    } catch (e) {
      return left(Failure());
    }

    return cityModel == null ? left(Failure()) : right(cityModel);
  }


}
