import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ride_the_weather/app_module.dart';
import 'package:ride_the_weather/app_widget.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModularApp(
      module: AppModule(),
      child: AppWidget(),
    );
  }
}