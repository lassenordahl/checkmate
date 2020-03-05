import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../objects/Task.dart';
import '../api/api.dart';

class LimboTasks extends StatefulWidget {
  final String filter;

  LimboTasks({Key key, this.filter}) : super(key: key);

  @override
  createState() => new LimboTasksState();
}

class LimboTasksState extends State<LimboTasks> {
  // List<Task> _completedTasks = [
  //   new Task(123, "Work Out", "Go work out lazy pants", "exercise", -1,
  //       new DateTime.now(), new DateTime.now(), 123, 123),
  //   new Task(124, "Study", "Study at langson", "academic", -1,
  //       new DateTime.now(), new DateTime.now(), 123, 123)
  // ];
  List<Task> _completedTasks = [];

  @override
  void initState() {
    _getPastTasks();
  }

  void _getPastTasks() async {
    print("getting completed tasks");
    List<Task> dbTasks = await getPastTasks();
    setState(() {
      _completedTasks = dbTasks;
    });
    print(_completedTasks);
  }

  void _completeTask(String taskId) async {
    putCompleted(taskId, 1, _getPastTasks);
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
                                    print("hey there");
                                    _completeTask(task.id);
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
