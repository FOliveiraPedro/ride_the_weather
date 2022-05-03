import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/weather_description/domain/errors/errors.dart';
import 'package:ride_the_weather/src/weather_description/presenter/states/weather_description_state.dart';
import 'package:ride_the_weather/src/weather_description/presenter/weather_description_bloc.dart';

class WeatherDescriptionPage extends StatefulWidget {
  late CityEntity? citySelected;

  WeatherDescriptionPage({
    Key? key,
    this.citySelected,
  }) : super(key: key);

  WeatherDescriptionPage.fromArgs(dynamic arguments) {
    citySelected = arguments.data['citySelected'];
  }

  static void navigate(CityEntity citySelected) {
    Modular.to.pushNamed(
      '/weather',
      arguments: {'citySelected': citySelected},
    );
  }

  @override
  _WeatherDescriptionPageState createState() => _WeatherDescriptionPageState();
}

class _WeatherDescriptionPageState
    extends ModularState<WeatherDescriptionPage, WeatherDescriptionBloc> {
  @override
  void initState() {
    super.initState();
    bloc.selectedCity = widget.citySelected!;
    bloc.add("update state");
  }

  Widget _buildBody(WeatherDescription weather) {
    return Column(
      children: [
        Text(
          weather.instantWeather.temp.toString() + "ºC",
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          weather.instantWeather.tempMax.toString() + "ºC",
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          weather.instantWeather.tempMin.toString() + "ºC",
          style: const TextStyle(fontSize: 18),
        ),
        Text(
          weather.instantWeather.weather.toString(),
          style: const TextStyle(fontSize: 18),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: bloc.report.length,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  Text(
                    bloc.report[index].date.day.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    bloc.report[index].tempMax.toString() + "ºC",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    bloc.report[index].tempMin.toString() + "ºC",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildError(Failure error) {
    if (error is ErrorSearch) {
      return const Center(
        child: Text('Erro no github'),
      );
    } else {
      return const Center(
        child: Text('Erro interno'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.citySelected!.name + ", " + widget.citySelected!.country),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<WeatherDescriptionState>(
              stream: bloc.stream,
              builder: (context, snapshot) {
                var state = bloc.state;
                if (state is ErrorState) {
                  return _buildError(state.error);
                }
                if (state is StartState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SuccessState) {
                  return _buildBody(state.weather);
                } else {
                  return Container();
                }
              }),
        )
      ]),
    );
  }
}
