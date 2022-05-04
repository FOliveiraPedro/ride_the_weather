import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/city_list/infra/datasources/search_city_datasource.dart';
import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';

@Injectable(singleton: false)
class SearchCityDatasourceImpl implements SearchCityDatasource {
  final Dio dio;

  SearchCityDatasourceImpl(this.dio);

  @override
  Future<CityModel?> searchCity(String cityName) async {
    var result = await dio.get(
        "http://api.openweathermap.org/geo/1.0/direct?q=$cityName&appid=5b289f3aeb1212ba00c03ae28fc2ed8e&limit=1");
    if (result.statusCode == 200) {
      var json = result.data[0];
      print(json);
      var city = CityModel.fromJson(json);
      return city;
    } else {
      throw Exception();
    }
  }
}
