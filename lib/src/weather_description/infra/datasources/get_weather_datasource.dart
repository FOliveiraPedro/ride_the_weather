import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

abstract class GetWeatherDatasource {
  Future<WeatherModel?> getInstantWeather(LatLon latLon);
  Future<List<WeatherModel>> getHistoricWeather(LatLon latLon);

}
