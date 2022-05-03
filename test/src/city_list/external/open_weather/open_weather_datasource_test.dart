import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_the_weather/src/weather_description/external/open_weather/get_weather_datasource_impl.dart';
import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

import 'open_weather_datasource_test.mocks.dart';

@GenerateMocks([Dio])
main() {
  var dio = MockDio();
  var datasource = GetWeatherDatasourceImpl(dio);
  LatLon validLatLon = LatLon(latitude: "-23.533773", longitude: "-46.625290");
  Response response = Response(
      data: jsonResponse,
      statusCode: 200,
      requestOptions: RequestOptions(path: ""));
  test('deve retornar um ResultModel', () async {
    when(dio.get(
            "https://api.openweathermap.org/data/2.5/weather?lat=-23.5506507&lon=-46.6333824&appid=5b289f3aeb1212ba00c03ae28fc2ed8e&units=metric"))
        .thenAnswer((_) async => response);

    var result = await datasource.getInstantWeather(validLatLon);
    expect(result, isA<WeatherModel>());
  });
}

var jsonResponse = '''{
    "weather": [
        {
            "description": "clear sky",
        }
    ],
    "main": {
        "temp": 20.95,
        "temp_min": 17.88,
        "temp_max": 21.3,
    },
}''';
