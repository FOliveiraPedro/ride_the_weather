import 'package:dartz/dartz.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';

abstract class SearchCityRepository{
  Future<Either<Failure, CityEntity>> getLocationData(String cityName);

}