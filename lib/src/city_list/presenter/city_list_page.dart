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
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, index) {
        return ListTile(
          onTap: () {
            WeatherDescriptionPage.navigate(CityEntity(
                name: list[index].name,
                country: list[index].country,
                latLon: list[index].latLon));
          },
          title: Text(list[index].name),
        );
      },
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
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(children: [
        Expanded(
          child: StreamBuilder<CityListState>(
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
              }),
        )
      ]),
    );
  }
}
