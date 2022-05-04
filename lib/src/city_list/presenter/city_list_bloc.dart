import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/usercase/search_city.dart';
import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';
import 'package:ride_the_weather/src/city_list/presenter/states/search_city_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class CityListBloc extends Bloc<String, CityListState> implements Disposable {
  final SearchCity searchCityUsercase;

  CityListBloc(this.searchCityUsercase) : super(const StartState());

  List<CityEntity> citys = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Stream<CityListState> mapEventToState(String event) async* {
    final SharedPreferences prefs = await _prefs;
    yield const LoadingState();
    ErrorState? errorState;
    List<String> cityNames = [
      "Silverstone",
      "São Paulo",
      "Melbourne",
      "Monte-Carlo"
    ];
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      for (int i = 0; i < cityNames.length; i++) {
        var result = await searchCityUsercase(cityNames[i]);
        result.fold(
          (failure) {
            errorState = ErrorState(failure);
          },
          (success) {
            citys.add(success);
            prefs.setString(
                success.name,
                json.encode(
                  {
                    "name": success.name,
                    "lat": success.latLon.latitude,
                    "lon": success.latLon.longitude,
                    "country": success.country,
                  },
                ));
          },
        );
      }
    } else {
      for (String item in cityNames) {
        String? storedCity = prefs.getString(item);
        citys.add(CityModel.fromJson(jsonDecode(storedCity!)));
      }
    }

    if (errorState != null) {
      yield errorState!;
    }
    yield SuccessState(citys);
  }

  @override
  Stream<Transition<String, CityListState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(const Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }

  @override
  void dispose() {
    close();
  }
}
