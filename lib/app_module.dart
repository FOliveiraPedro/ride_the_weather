import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/city_list/domain/repositories/search_city_repository.dart';
import 'package:ride_the_weather/src/city_list/domain/usercase/search_city.dart';
import 'package:ride_the_weather/src/city_list/external/open_weather/search_city_datasource_impl.dart';
import 'package:ride_the_weather/src/city_list/infra/datasources/search_city_datasource.dart';
import 'package:ride_the_weather/src/city_list/infra/repositories/search_city_repository_impl.dart';
import 'package:ride_the_weather/src/city_list/presenter/city_list_bloc.dart';
import 'package:ride_the_weather/src/city_list/presenter/city_list_page.dart';
import 'package:ride_the_weather/src/weather_description/domain/repositories/weather_repository.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercases/get_historic_weather.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercases/get_instant_weather.dart';
import 'package:ride_the_weather/src/weather_description/external/open_weather/get_weather_datasource_impl.dart';
import 'package:ride_the_weather/src/weather_description/infra/datasources/get_weather_datasource.dart';
import 'package:ride_the_weather/src/weather_description/infra/repositories/get_weather_repository_impl.dart';
import 'package:ride_the_weather/src/weather_description/presenter/weather_description_bloc.dart';
import 'package:ride_the_weather/src/weather_description/presenter/weather_description_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => Dio()),
    //Weather Description
    BindInject(
      (i) => GetHistoricWeatherImpl(i<WeatherRepository>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => GetInstantWeatherImpl(i<WeatherRepository>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => WeatherRepositoryImpl(i<GetWeatherDatasource>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => GetWeatherDatasourceImpl(i<Dio>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => WeatherDescriptionBloc(
          i<GetInstantWeather>(), i<GetHistoricWeather>()),
      isSingleton: false,
      isLazy: true,
    ),
    //City List
    BindInject(
      (i) => SearchCityImpl(i<SearchCityRepository>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => SearchCityRepositoryImpl(i<SearchCityDatasource>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => SearchCityDatasourceImpl(i<Dio>()),
      isSingleton: false,
      isLazy: true,
    ),
    BindInject(
      (i) => CityListBloc(i<SearchCity>()),
      isSingleton: false,
      isLazy: true,
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const CityListPage()),
    ChildRoute('/weather',
        child: (_, args) => WeatherDescriptionPage.fromArgs(args)),
  ];
}
