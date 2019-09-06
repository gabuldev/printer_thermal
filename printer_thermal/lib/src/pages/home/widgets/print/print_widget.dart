import 'package:flutter/material.dart';
import 'package:printer_thermal/src/pages/home/home_module.dart';
import 'package:printer_thermal/src/pages/home/widgets/print/print_bloc.dart';

class PrintWidget extends StatefulWidget {

  @override
  _PrintWidgetState createState() => _PrintWidgetState();
}

class _PrintWidgetState extends State<PrintWidget> {
  var bloc = HomeModule.to.getBloc<PrintBloc>();
  var controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      onSaved: (value) => bloc.texto = value,
                      validator: (value) => value.isEmpty ? "Nao pode ser nulo" : null,
                    decoration: InputDecoration(
                      labelText: "Texto"
                    ),
                    )
                  ],
                ),
              ),
            ),

            RaisedButton(
              child: Text("Imprimir"),
              onPressed: (){
                if(controller.validate())
                  bloc.print();
              },
            )

      ],),
    );
  }
}

class Controller{
   var formKey = GlobalKey<FormState>();

  bool validate(){
    var form = formKey.currentState;

      if(form.validate()){
        form.save();
        return true;
      }
      else{
        return false;
      }
  }

}
