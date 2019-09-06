import 'package:printer_thermal/src/pages/home/widgets/print/print_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:printer_thermal/src/shared/printer/printer_bloc.dart';

import 'home_bloc.dart';
import 'home_page.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => PrintBloc()),
        Bloc((i) => HomeBloc()),
        Bloc((i) => PrinterBloc())
      ];

  @override
  List<Dependency> get dependencies => [];

  @override
  Widget get view => HomePage();

  static Inject get to => Inject<HomeModule>.of();
}
