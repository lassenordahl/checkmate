import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../detailPanels/taskDescription.dart';
import '../pageRouteBuilders/openCardRoute.dart';

import '../objects/Task.dart';

class ScheduledTasks extends StatefulWidget {
  @override
  createState() => new ScheduledTasksState();
}

class ScheduledTasksState extends State<ScheduledTasks> {
  List<Task> _scheduledTasks = [
    new Task(123, "Work Out", "Go work out lazy pants", "exercise", -1, new DateTime(1), new DateTime(2), 123, 123),
    new Task(124, "Study", "Study at langson", "academic", -1, new DateTime(1), new DateTime(2), 123, 123)
  ];

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new Column(
      children: <Widget>[for (var item in _scheduledTasks) _buildScheduledTask(item)],
    );
  }

  // Build a single todo item
  Widget _buildScheduledTask(Task task) {
    return new Container(
      padding: EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0),
      child: GestureDetector(
        onTap: () {
          print("clicked ");
          Navigator.push(context, OpenCardRoute(page: TaskDescription()));
        },
        child: Hero(
          tag: 'TaskHero' + task.id.toString(),
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
                          Text(
                            task.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              task.description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[],
                      )
                    ])),
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
