import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    // Bind.factory((i) => HomeStore(i())),
    // Bind.lazySingleton((i) => GetSpaceMediaFromDateUsecase(i())),
    // Bind.lazySingleton((i) => SpaceMediaRepositoryImplementation(i())),
    // Bind.lazySingleton((i) => SpaceMediaDatasouceImplementation(converter: i(), client: i())),
    // Bind.lazySingleton((i) => http.Client()),
    // Bind.lazySingleton((i) => DateInputConverter()),
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute('/', child: (_, __) => HomePage()),
    // ChildRoute('/picture', child: (_, args) => PicturePage.fromArgs(args.data)),
  ];
}