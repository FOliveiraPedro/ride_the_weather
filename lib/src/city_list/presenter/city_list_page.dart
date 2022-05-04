import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/src/city_list/domain/entities/city_entity.dart';
import 'package:ride_the_weather/src/city_list/domain/errors/errors.dart';
import 'package:ride_the_weather/src/city_list/presenter/city_list_bloc.dart';
import 'package:ride_the_weather/src/city_list/presenter/states/search_city_state.dart';
import 'package:ride_the_weather/src/weather_description/presenter/weather_description_page.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({Key? key}) : super(key: key);

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends ModularState<CityListPage, CityListBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add("update state");
  }

  Widget _buildBody(List<CityEntity> list) {
    return Container(
      margin: const EdgeInsets.only(right: 8, left: 8, top: 8),
      decoration: const BoxDecoration(
        color: Color(0xff252541),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      height: 246,
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  WeatherDescriptionPage.navigate(CityEntity(
                      name: list[index].name,
                      country: list[index].country,
                      latLon: list[index].latLon));
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        list[index].name + ", " + list[index].country,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff252541),
                    borderRadius: list[index] == list.first
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0))
                        : list[index] == list.last
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0))
                            : const BorderRadius.all(Radius.circular(0.0)),
                  ),
                  
                ),
              ),
              list[index] != list.last
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
        title: const Text("Ride the Weather"),
        centerTitle: true,
        backgroundColor: const Color(0xff252541),
      ),
      body: Column(children: [
        StreamBuilder<CityListState>(
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
                return _buildBody(state.list);
              } else {
                return Container();
              }
            })
      ]),
    );
  }
}
