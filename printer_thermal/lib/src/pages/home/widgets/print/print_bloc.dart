import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:printer_thermal/src/pages/home/home_module.dart';
import 'package:printer_thermal/src/shared/printer/printer_bloc.dart';

class PrintBloc extends BlocBase {

  String texto;

  void print(){

    var printer = HomeModule.to.getBloc<PrinterBloc>();

    printer.print(texto);


  }

  @override
  void dispose() {
    super.dispose();
  }
}
