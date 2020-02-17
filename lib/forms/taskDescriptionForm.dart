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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: widget.selectedTask.name,
            decoration: new InputDecoration(
              labelText: 'Task Name',
              focusColor: Color(0xfff88379),
            ),
            style: new TextStyle(color: Colors.black),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          SizedBox(height: 8.0),
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: widget.selectedTask.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: new InputDecoration(
              labelText: 'Task Description',
              focusColor: Color(0xfff88379),
            ),
            style: new TextStyle(color: Colors.black),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
