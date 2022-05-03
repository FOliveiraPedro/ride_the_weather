// import 'dart:convert';

// import 'package:dartz/dartz.dart';
// import 'package:flutter_modular/flutter_modular.dart'  as module;
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:modular_test/modular_test.dart';
// import 'package:ride_the_weather/app_module.dart';
// import 'package:ride_the_weather/src/weather_description/domain/entities/weather_data_entity.dart';
// import 'package:ride_the_weather/src/weather_description/domain/usercases/get_instant_weather.dart';
// import 'package:ride_the_weather/src/weather_description/presenter/states/weather_description_state.dart';
// import 'package:ride_the_weather/src/weather_description/presenter/weather_description_bloc.dart';
// import 'package:ride_the_weather/src/weather_description/utils/lat_lon.dart';

// import 'weather_description_bloc_test.mocks.dart';

// @GenerateMocks([GetInstantWeather])
// main() {
//   var usercase = MockGetWeather();

//   initModule(AppModule(), replaceBinds: [
//     module.Bind.instance<GetInstantWeather>(usercase),
//   ]);

//   WeatherEntity weatherEntity =
//       WeatherEntity(weather: "", temp: "", tempMin: "", tempMax: "", date:  DateTime.parse(""));
//   LatLon validLatLon = LatLon(latitude: "-23.533773", longitude: "-46.625290");
//   test('deve emitir sequencia correta de estados', () async {
//     var bloc = module.Modular.get<WeatherDescriptionBloc>();
//     when(usercase.call(validLatLon))
//         .thenAnswer((_) async => Right(weatherEntity));
   
//     expectLater(
//         bloc,
//         emitsInOrder([
//           isA<LoadingState>(),
//           isA<SuccessState>(),
//         ]));
//     bloc.add('states');
//   });
// }
