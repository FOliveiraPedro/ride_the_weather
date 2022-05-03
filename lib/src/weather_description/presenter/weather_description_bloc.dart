import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/infra/models/city_model.dart';
import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercases/get_historic_weather.dart';
import 'package:ride_the_weather/src/weather_description/domain/usercases/get_instant_weather.dart';
import 'package:ride_the_weather/src/weather_description/infra/models/weather_model.dart';
import 'package:ride_the_weather/src/weather_description/presenter/states/weather_description_state.dart';
import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable()
class WeatherDescriptionBloc extends Bloc<String, WeatherDescriptionState>
    implements Disposable {
  final GetInstantWeather getInstantWeatherUsercase;
  final GetHistoricWeather getHistoricWeatherUsercase;

  WeatherDescriptionBloc(
      this.getInstantWeatherUsercase, this.getHistoricWeatherUsercase)
      : super(const StartState());

  WeatherDescription weatherDescription = WeatherDescription(
      WeatherEntity(
          date: DateTime.parse("0000-00-00 00:00:00"),
          temp: "",
          tempMax: "",
          tempMin: "",
          weather: ""),
      []);

  late CityEntity selectedCity;

  List<WeatherEntity> report = [];

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Stream<WeatherDescriptionState> mapEventToState(String event) async* {
    final SharedPreferences prefs = await _prefs;
    yield const LoadingState();
    ErrorState? errorState;

    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      var instantResult = await getInstantWeatherUsercase(LatLon(
          latitude: selectedCity.latLon.latitude,
          longitude: selectedCity.latLon.longitude));
      instantResult.fold(
        (failure) {
          errorState = ErrorState(failure);
        },
        (success) {
          weatherDescription.instantWeather = success;
          print(selectedCity.name);
          prefs.setString(
              selectedCity.name + "_instant",
              json.encode(
                {
                  "weather": [
                    {
                      "description": success.weather,
                    }
                  ],
                  "main": {
                    "temp": success.temp.toString(),
                    "temp_min": success.tempMin.toString(),
                    "temp_max": success.tempMax.toString(),
                  },
                },
              ));
        },
      );
      var result = await getHistoricWeatherUsercase(
          LatLon(latitude: "-23.533773", longitude: "-46.625290"));
      result.fold(
        (failure) {
          errorState = ErrorState(failure);
        },
        (success) {
          List<String> cityDescription = [];
          weatherDescription.historicWeather = success;
          for (WeatherEntity item in success) {
            cityDescription.add(json.encode(
              {
                "weather": [
                  {
                    "description": item.weather,
                  }
                ],
                "main": {
                  "temp": item.temp.toString(),
                  "temp_min": item.tempMin.toString(),
                  "temp_max": item.tempMax.toString(),
                },
                "dt_txt": item.date.toString()
              },
            ));
          }
          prefs.setStringList(selectedCity.name + "_historic", cityDescription);
        },
      );
      createReport();
    } else {
      print(selectedCity.name);
      String? instantWeather = prefs.getString(selectedCity.name + "_instant");
      print(instantWeather);
      weatherDescription.instantWeather =
          WeatherModel.fromJson(jsonDecode(instantWeather!));
      List<String>? historicWeather =
          prefs.getStringList(selectedCity.name + '_historic');
      print(historicWeather);
      for (String item in historicWeather!) {
        weatherDescription.historicWeather
            .add(WeatherModel.fromJson(jsonDecode(item)));
      }
      createReport();
    }

    if (errorState != null) {
      yield errorState!;
    }
    yield SuccessState(weatherDescription);
  }

  @override
  Stream<Transition<String, WeatherDescriptionState>> transformEvents(
      Stream<String> events, transitionFn) {
    events = events.debounceTime(const Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }

  void createReport() {
    print("createReport");
    int daysQuant = -1;
    DateTime auxDay = DateTime.parse("0000-00-00 00:00:00");
    for (var item in weatherDescription.historicWeather) {
      if (item.date.day != auxDay.day) {
        auxDay = item.date;
        daysQuant++;
      }
    }

    int i = 0;
    for (int j = 0; j < daysQuant; j++) {
      WeatherEntity auxWeather = WeatherEntity(
          weather: "",
          temp: "",
          tempMin: "100.0",
          tempMax: "0.0",
          date: DateTime.parse("0000-00-00 00:00:00"));
      if (j == 0) {
        auxWeather.date = weatherDescription.historicWeather[j].date;
      } else {
        auxWeather.date = weatherDescription.historicWeather[i].date;
      }
      while (auxWeather.date.day ==
          weatherDescription.historicWeather[i].date.day) {
        if (double.parse(auxWeather.tempMin) >
            double.parse(weatherDescription.historicWeather[i].tempMin)) {
          auxWeather.tempMin = weatherDescription.historicWeather[i].tempMin;
        }
        if (double.parse(auxWeather.tempMax) <
            double.parse(weatherDescription.historicWeather[i].tempMax)) {
          auxWeather.tempMax = weatherDescription.historicWeather[i].tempMax;
        }
        i++;
        if (i == 40) {
          break;
        }
      }
      report.add(auxWeather);
    }
  }

  @override
  void dispose() {
    close();
  }
}

class WeatherDescription {
  WeatherEntity instantWeather;
  List<WeatherEntity> historicWeather;

  WeatherDescription(this.instantWeather, this.historicWeather);
}
