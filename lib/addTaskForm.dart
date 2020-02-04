// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddTaskForm extends StatefulWidget {
  @override
  AddTaskFormState createState() {
    return AddTaskFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class AddTaskFormState extends State<AddTaskForm> {
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
        width: 100,
        child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              TextFormField(
                // The validator receives the text that the user has entered.
                decoration: new InputDecoration(
                  labelText: 'Task title',
                  focusColor: Color(0xfff88379),
                  // focusedBorder: OutlineInputBorder(
                  //     borderSide:
                  //         BorderSide(color: Color(0xfff88379), width: 1.0)),
                  //   enabledBorder: OutlineInputBorder(
                  //     // width: 0.0 produces a thin "hairline" border
                  //     borderSide:
                  //         const BorderSide(color: Color(0xfff88379), width: 0.0),
                  //   ),
                ),

                style: new TextStyle(color: Colors.white),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )
            ])));
  }
}
