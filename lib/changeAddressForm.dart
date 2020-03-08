// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChangeAddressForm extends StatefulWidget {
  @override
  ChangeAddressFormState createState() {
    return ChangeAddressFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class ChangeAddressFormState extends State<ChangeAddressForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
        width: 300,
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              Text(
                '   ',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              Text(
                  'Enter home address information below:',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,

                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 15)
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: new InputDecoration(
                  labelText: 'Street Name',
                  focusColor: Color(0xfff88379),

                ),

                style: new TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your residential street';
                  }
                  return null;
                },
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: new InputDecoration(
                  labelText: 'City Name',
                  focusColor: Color(0xfff88379),
                ),

                style: new TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your residential city';
                  }
                  return null;
                },
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: new InputDecoration(
                  labelText: 'Zip Code',
                  focusColor: Color(0xfff88379),
                ),

                style: new TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your residential zip code';
                  }
                  return null;
                },
              ),
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: new InputDecoration(
                  labelText: 'Country',
                  focusColor: Color(0xfff88379),
                ),

                style: new TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your residential country';
                  }
                  return null;
                },
              ),
              Text(
                '   ',
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              RaisedButton(
                child: Text("Submit"),
                onPressed: _submitAddress,
                color: Colors.greenAccent,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
            ])));

  }

  _submitAddress() {
    // some action to pass address to back end?
  }
}
