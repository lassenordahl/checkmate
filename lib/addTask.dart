import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';

import 'objects/Task.dart';
import 'forms/taskDescriptionForm.dart';

class AddTask extends StatefulWidget {
  AddTask({Key key, this.title}) : super(key: key);

  final String title;

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  String _value;
  String _value2;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<TaskDescriptionFormState> formState =
      GlobalKey<TaskDescriptionFormState>();

  void _submitTask() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("Valid form");
      formState.currentState.submitForm();
    } else {
      print("Invalid form");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          _submitTask();
        },
        child: Icon(Icons.create),
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: double.maxFinite,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 64.0,
                  left: 32.0,
                  right: 32.0,
                  bottom: 24.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create a Task",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  bottom: 32.0,
                ),
                child: new TaskDescriptionForm(
                  key: formState,
                  formKey: _formKey,
                  selectedTask: new Task(),
                  textColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
