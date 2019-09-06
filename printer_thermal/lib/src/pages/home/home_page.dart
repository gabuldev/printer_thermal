import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:printer_thermal/src/pages/home/home_module.dart';
import 'package:printer_thermal/src/pages/home/widgets/print/print_widget.dart';
import 'package:printer_thermal/src/shared/printer/printer_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  var printer = HomeModule.to.getBloc<PrinterBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Column(
        children: <Widget>[

          StreamBuilder<Status>(
            stream: printer.statusOut,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()),);
              }
              else if(snapshot.hasData){
            
              switch (snapshot.data) {
                case Status.connected:return Column(
                  children: <Widget>[
                    Text("Conectado"),
                    RaisedButton(
                      child: Text("Desconectar"),
                      onPressed: (){
                        printer.disconnect();
                      },
                    )
                  ],
                );
                break;
                 case Status.disconnected: return Text("Desconectado");
                break;
                case Status.awaiting: return CircularProgressIndicator();
                break;
                default: return Text("Error");
              }
              }
             else{
               return Text("Selecione uma impressora");
             } 
            }
          ),

          StreamBuilder<List<BluetoothDevice>>(
            stream: printer.getDevices(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text(snapshot.error.toString()),);
              }
              else if(snapshot.hasData){
              return Column(
                children: snapshot.data.map((item) => ListTile(
                  onTap: (){
                    printer.selectDevice(item);
                    
                  },
                  title: Text(item.name),)).toList(),
              );
              }
             else{
               return Center(child: CircularProgressIndicator(),);
             } 
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.print),
        onPressed: (){
          showDialog(
            context: context,
            builder: (context) => PrintWidget()  
          );
        },
      ),
    );
  }
}
