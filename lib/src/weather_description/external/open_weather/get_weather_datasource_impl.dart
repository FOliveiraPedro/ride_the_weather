import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/weather_description/infra/datasources/get_weather_datasource.dart';
import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

@Injectable(singleton: false)
class GetWeatherDatasourceImpl implements GetWeatherDatasource {
  final Dio dio;

  GetWeatherDatasourceImpl(this.dio);

  @override
  Future<WeatherModel?> getInstantWeather(LatLon latLon) async {
    var result = await dio.get(
        "https://api.openweathermap.org/data/2.5/weather?lat=${latLon.latitude}&lon=${latLon.longitude}&appid=5b289f3aeb1212ba00c03ae28fc2ed8e&units=metric");
    if (result.statusCode == 200) {
      var json = result.data;
      var weather = WeatherModel.fromJson(json);
      return weather;
    } else {
      throw Exception();
    }
  }

  @override
  Future<List<WeatherModel>> getHistoricWeather(LatLon latLon) async {
    var result = await dio.get(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${latLon.latitude}&lon=${latLon.longitude}&appid=5b289f3aeb1212ba00c03ae28fc2ed8e&units=metric");

    if (result.statusCode == 200) {
      var jsonList = result.data["list"] as List;
      var list = jsonList.map((item) => WeatherModel.fromJson(item)).toList();

      return list;
    } else {
      throw Exception();
    }
  }
}
