// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../objects/Task.dart';

class TaskDescriptionForm extends StatefulWidget {

  final Task selectedTask;

  TaskDescriptionForm({Key key, this.selectedTask});

  @override
  createState() => TaskDescriptionFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class TaskDescriptionFormState extends State<TaskDescriptionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      width: 100,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // The validator receives the text that the user has entered.
              decoration: new InputDecoration(
                labelText: 'Task Name',
                focusColor: Color(0xfff88379),
              ),
              style: new TextStyle(color: Colors.white),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
