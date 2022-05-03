import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';

abstract class CityListState {}

class StartState implements CityListState {
  const StartState();
}

class LoadingState implements CityListState {
  const LoadingState();
}

class ErrorState implements CityListState {
  final Failure error;
  const ErrorState(this.error);
}

class SuccessState implements CityListState {
  final List<CityEntity> list;
  const SuccessState(this.list);
}
