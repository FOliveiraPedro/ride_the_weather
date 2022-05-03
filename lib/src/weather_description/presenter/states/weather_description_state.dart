import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/presenter/weather_description_bloc.dart';

abstract class WeatherDescriptionState {}

class StartState implements WeatherDescriptionState {
  const StartState();
}

class LoadingState implements WeatherDescriptionState {
  const LoadingState();
}

class ErrorState implements WeatherDescriptionState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements WeatherDescriptionState {
  final WeatherDescription weather;
  const SuccessState(this.weather);
}
