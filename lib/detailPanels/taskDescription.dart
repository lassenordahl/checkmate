import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../forms/taskDescriptionForm.dart';
import '../objects/Task.dart';

class TaskDescription extends StatefulWidget {
  final Task selectedTask;

  TaskDescription({Key key, this.selectedTask});

  @override
  createState() => new TaskDescriptionState();
}

class TaskDescriptionState extends State<TaskDescription> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<TaskDescriptionFormState> formState =
      GlobalKey<TaskDescriptionFormState>();

  double currentOpacity = 0.0;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        currentOpacity = 1.0;
      });
    });
  }

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
    return new Hero(
      tag: widget.selectedTask.id.toString(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            _submitTask();
          },
          child: Icon(Icons.save),
          backgroundColor: Color(0xfff88379),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: double.maxFinite,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.white, Colors.white])),
            child: AnimatedOpacity(
              opacity: currentOpacity,
              duration: const Duration(seconds: 1),
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
                                "Edit a Task",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentOpacity = 0.0;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 26,
                                ),
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
                      selectedTask: widget.selectedTask,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
