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
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    bloc.selectedCity = widget.citySelected!;
    bloc.add("update state");
  }

  Widget _buildBody(WeatherDescription weather) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xff252541),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    double.parse(weather.instantWeather.temp)
                            .round()
                            .toString() +
                        "ºC",
                    style: const TextStyle(fontSize: 48, color: Colors.white),
                  ),
                  Text(
                    weather.instantWeather.weather.toString(),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Min",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            double.parse(weather.instantWeather.tempMin)
                                    .round()
                                    .toString() +
                                "ºC",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Max",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            double.parse(weather.instantWeather.tempMin)
                                    .round()
                                    .toString() +
                                "ºC",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8, left: 8, top: 8),
          decoration: const BoxDecoration(
            color: Color(0xff252541),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          height: 246,
          child: ListView.builder(
            itemCount: bloc.report.length,
            itemBuilder: (BuildContext context, index) {
              return Column(
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xff252541),
                      borderRadius: bloc.report[index] == bloc.report.first
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0))
                          : bloc.report[index] == bloc.report.last
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0))
                              : const BorderRadius.all(Radius.circular(0.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            months[bloc.report[index].date.month - 1] +
                                ", " +
                                bloc.report[index].date.day.toString(),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                double.parse(bloc.report[index].tempMin)
                                        .round()
                                        .toString() +
                                    "ºC",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                double.parse(bloc.report[index].tempMax)
                                        .round()
                                        .toString() +
                                    "ºC",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  bloc.report[index] != bloc.report.last
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.92,
                          child: Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.grey.shade700,
                          ),
                        )
                      : Container()
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
      backgroundColor: const Color(0xff161627),
      appBar: AppBar(
        title: Text(
            widget.citySelected!.name + ", " + widget.citySelected!.country),
        centerTitle: true,
        backgroundColor: const Color(0xff252541),
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
