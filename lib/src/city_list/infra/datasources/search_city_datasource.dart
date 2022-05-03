import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';

abstract class SearchCityDatasource {
  Future<CityModel?> searchCity(String cityName);

}
