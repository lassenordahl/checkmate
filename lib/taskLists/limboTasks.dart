import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../objects/Task.dart';
import '../api/api.dart';
import '../detailPanels/taskDescription.dart';
import '../pageRouteBuilders/openCardRoute.dart';

class LimboTasks extends StatefulWidget {
  final String filter;

  LimboTasks({Key key, this.filter}) : super(key: key);

  @override
  createState() => new LimboTasksState();
}

class LimboTasksState extends State<LimboTasks> {

  List<Task> _completedTasks = [];

  @override
  void initState() {
    getPastTasks();
  }

  void getPastTasks() async {
    List<Task> dbTasks = await getPast();
    setState(() {
      _completedTasks = dbTasks;
    });
  }

  void _completeTask(String taskId, int completed, Task task) async {
    if (completed == 0) {
      _showDialog(taskId, completed, task);
    } else {
      putCompleted(taskId, completed, getPastTasks);
    }
  }

  void _showDialog(String taskId, int completed, Task task) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Reschedule Task?"),
          content: new Text("You didn't complete the task, would you like to reschedule it?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Reschedule"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  OpenCardRoute(
                    page: new TaskDescription(
                      selectedTask: task,
                    ),
                  ),
                );
              },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                putCompleted(taskId, completed, getPastTasks);
              },
            ),
          ],
        );
      },
    );
  }

  // Build the whole list of todo items
  Widget _buildCompletedList() {
    List<Task> _filteredTasks = _completedTasks
        .where((task) =>
            task.name.toLowerCase().contains(widget.filter.toLowerCase()) ||
            task.taskType.toLowerCase().contains(widget.filter.toLowerCase()))
        .toList();

    if (_filteredTasks.length > 0) {
      return new Column(
        children: <Widget>[
          for (var item in _filteredTasks) _buildCompletedItem(item)
        ],
      );
    } else {
      return new Column(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 28.0),
              child: Text(
                "No tasks",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      );
    }
  }

  _formatTime(DateTime startTime, DateTime endTime) {
    var formatter = new DateFormat('MMM dd,').add_jm();
    var endFormatter = new DateFormat().add_jm();
    String formattedDate = formatter.format(startTime);
    String endFormattedDate = endFormatter.format(endTime);
    return formattedDate + " - " + endFormattedDate; // 2016-01-25
  }

  // Build a single todo itemƒƒ
  Widget _buildCompletedItem(Task task) {
    return new Container(
      padding: EdgeInsets.only(bottom: 28.0, left: 28.0, right: 28.0),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            new BoxShadow(
                color: Colors.black.withOpacity(0.3),
                // offset, the X,Y coordinates to offset the shadow
                offset: new Offset(0.0, 7.0),
                // blurRadius, the higher the number the more smeared look
                blurRadius: 10.0,
                spreadRadius: 0.1)
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      _formatTime(task.startTime, task.endTime),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Material(
                        color: Colors.grey,
                        child: Center(
                          child: Ink(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.white,
                              ),
                              child: IconButton(
                                  icon: Icon(Icons.check),
                                  color: Colors.green,
                                  onPressed: () {
                                    _completeTask(task.id, 1, task);
                                  })),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Material(
                          color: Colors.grey,
                          child: Center(
                            child: Ink(
                              decoration: const ShapeDecoration(
                                shape: CircleBorder(),
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.clear),
                                color: Colors.red,
                                onPressed: () {
                                  print("hey bear");
                                  _completeTask(task.id, 0, task);
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCompletedList();
  }
}
