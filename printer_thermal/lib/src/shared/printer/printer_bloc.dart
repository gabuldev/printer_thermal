import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

enum Status{
  connected,disconnected,error,awaiting
}

class PrinterBloc extends BlocBase{

//!CONSTRUCTOR
    PrinterBloc(){
    bluetooth = BlueThermalPrinter.instance;
    statusOut = status.stream;
    deviceOut = device.stream;

    initListen();
  }

  
  BlueThermalPrinter bluetooth;
  
  //!STREAM SUBSCRIPTION
  StreamSubscription observeBluetooth;
  StreamSubscription observeDevice;

  //! STREAMS
  var status = PublishSubject<Status>();
  Observable<Status> statusOut;
  Sink<Status> get statusIn => status.sink;

  var device = PublishSubject<BluetoothDevice>();
  Observable<BluetoothDevice> deviceOut;
  Sink<BluetoothDevice> get deviceIn => device.sink;

void initListen(){

  bluetooth.isConnected.then((isConnected){
    if(isConnected){
      statusIn.add(Status.connected);
    }
  });

   observeBluetooth =   bluetooth.onStateChanged().listen((data){
     switch (data) {
      case BlueThermalPrinter.CONNECTED: statusIn.add(Status.connected);
      break;
      case BlueThermalPrinter.DISCONNECTED: statusIn.add(Status.disconnected);
      break;
      default:statusIn.add(Status.error);
    }
  });

  observeDevice = device.listen((data){
    try{
      bluetooth.isConnected.then((isConnected)async{
        if(!isConnected){
          bluetooth.connect(data);
        }
        else{
          await bluetooth.disconnect();
        }
      });
    }catch(e)
    {
      status.addError(e);
    }
  });
}

///
///Return list devices you can connect for print
///
  Stream <List<BluetoothDevice>> getDevices() async* {
    try{
    yield await bluetooth.getBondedDevices();
    }
    catch(e){
      throw e;
    }
  }

  void selectDevice(BluetoothDevice data){
    statusIn.add(Status.awaiting);
    deviceIn.add(data);
  }

  void disconnect()async{
    statusIn.add(Status.awaiting);
    await bluetooth.disconnect();
  }

  void print(String text) async{
      bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printCustom("GABUL DEV",3,1);
        bluetooth.printNewLine();
        bluetooth.printCustom(text, 2, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
        }
   });
  }




@override 
void dispose(){
  device.close();
  status.close();
  observeDevice.cancel();
  observeBluetooth.cancel();
  super.dispose();
}






}