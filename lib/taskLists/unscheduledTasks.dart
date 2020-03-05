import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../detailPanels/taskDescription.dart';
import '../pageRouteBuilders/openCardRoute.dart';
import '../components/taskTypeTag.dart';
import '../objects/Task.dart';
import '../api/api.dart';

class UnscheduledTasks extends StatefulWidget {
  final String filter;

  UnscheduledTasks({Key key, @required this.filter}) : super(key: key);

  @override
  createState() => new UnscheduledTasksState();
}

class UnscheduledTasksState extends State<UnscheduledTasks> {

  List<Task> _unscheduledTasks = [];

  @override
  void initState() {
    _getUnscheduledTasks();
  }

  void _getUnscheduledTasks() async {
    List<Task> dbTasks = await getUnscheduledTasks();
    setState(() {
      _unscheduledTasks = dbTasks;
    });
    print(_unscheduledTasks);
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    List<Task> _filteredTasks = _unscheduledTasks.where((task) => task.name.toLowerCase().contains(widget.filter.toLowerCase()) || task.taskType.toLowerCase().contains(widget.filter.toLowerCase())).toList();

    if (_filteredTasks.length > 0) {
      return new Column(
        children: <Widget>[
          for (var item in _filteredTasks) _buildScheduledTask(item)
        ],
      );
    }else {
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

  // Build a single todo item
  Widget _buildScheduledTask(Task task) {
    return new Container(
      padding: EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0),
      child: GestureDetector(
        onTap: () {
          print("clicked ");
          Navigator.push(
              context,
              OpenCardRoute(
                  page: TaskDescription(
                selectedTask: task,
              )));
        },
        child: Hero(
          tag: task.id.toString(),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
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
                      Row(
                        children: <Widget>[
                          Text(
                            task.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 14.0),
                          TaskTypeTag(taskType: task.taskType),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          _formatTime(task.startTime, task.endTime),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTodoList();
  }
}
