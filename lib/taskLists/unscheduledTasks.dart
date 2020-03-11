import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../detailPanels/taskDescription.dart';
import '../pageRouteBuilders/openCardRoute.dart';
import '../components/taskTypeTag.dart';
import '../objects/Task.dart';
import '../api/api.dart';

import 'package:geolocator/geolocator.dart';
import 'dart:collection';
import 'dart:math' show cos, sqrt, asin;

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
    getUnscheduledTasks();
  }

  _getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  //Sort Tasks based on context
  Future<List<Task>> sortTasks(var tasks) async {
      //Split Tasks into 3 Lists
      List<Task> list1=[];
      List<Task> list2=[];
      List<Task> list3=[];
      
      for (var item in tasks) {
          print(item.priority);
          if(item.priority == 1){print("enter1"); list1.add(item);}
          else if(item.priority == 2){print("enter2"); list2.add(item);}
          else if(item.priority == 3){print("enter3"); list3.add(item);}
      }
      print(list1);
      print(list2);
      print(list3);
      for (var item in list3) { print(item.name) ;}

      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      double currentLocationLat = position.latitude;
      double currentLocationLong = position.longitude;

      //Calculate Distance
      double getDistance(var lat, var long){
        var p = 0.017453292519943295;
        var c = cos;
        var a = 0.5 - c((lat - currentLocationLat) * p)/2 + 
              c(currentLocationLat * p) * c(lat * p) * 
              (1 - c((long - currentLocationLong) * p))/2;
        return 12742 * asin(sqrt(a));
      }

      //Assing each task a distance of current location from task
      HashMap taskDistances = new HashMap<String, double>(); // (Task_id, distanceFromTask)
      for (var item in tasks) {
          taskDistances[item.id] = getDistance(item.lat, item.long);
      }

      //Sort Function
      int sort_Tasks(var a, var b){
        if( taskDistances[a.id] > taskDistances[b.id]){
          return 1; //a is a closer distance
        }else{
          return -1; //a ordered after cause longer distance
        }
      }

      //Sort the 3 lists by Distance
      
      if(list1 != null) list1.sort( (a,b) => sort_Tasks(a, b) );
      if(list2 != null) list2.sort( (a,b) => sort_Tasks(a, b) );
      if(list3 != null) list3.sort( (a,b) => sort_Tasks(a, b) );

      //Merge 3 lists into one in correct order based on priority!
      List<Task> mainTasks=[];
      if(list1 != null) for (var item in list1) mainTasks.add(item);
      if(list2 != null) for (var item in list2) mainTasks.add(item);    
      if(list3 != null) for (var item in list3) mainTasks.add(item);

      //Return mainTasks
      return mainTasks;
  }

  void getUnscheduledTasks() async {
    List<Task> dbTasks = await getUnscheduled();

    //Sort Unscheduled tasks by priority, distance from task, then by task time
    dbTasks = await sortTasks(dbTasks);

    setState(() {
      print("Enter");
      _unscheduledTasks = dbTasks;
    });
    print("********************");
    print(_unscheduledTasks);
    print("********************");
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    List<Task> _filteredTasks = _unscheduledTasks
        .where((task) =>
            task.name.toLowerCase().contains(widget.filter.toLowerCase()) ||
            task.taskType.toLowerCase().contains(widget.filter.toLowerCase()))
        .toList();

    if (_filteredTasks.length > 0) {
      return new Column(
        children: <Widget>[
          for (var item in _filteredTasks) _buildScheduledTask(item)
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

  _formatTime(DateTime startTime, int taskTime) {
    var formatter = new DateFormat('MMM dd,').add_jm();
     var endFormatter = new DateFormat().add_jm();
    DateTime endTime = startTime.add(Duration(hours: taskTime));
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
                          TaskTypeTag(taskType: task.taskType, activated: 0),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14.0),
                        child: Text(
                          "Priority: " + task.priority.toString(),
                          // _formatTime(task.startTime, task.taskTime),
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
                    children: <Widget>[
                      // Text(
                      //   task.priority.toString(),
                      //   style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w400),
                      // )
                    ],
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
