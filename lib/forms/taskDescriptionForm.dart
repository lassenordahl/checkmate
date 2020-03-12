// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '../components/typeTagButton.dart';
import '../objects/Task.dart';
import '../objects/ScheduleTime.dart';
import '../search_map_place/search_map_place.dart';
import '../time-spinner/flutter_time_picker_spinner.dart';
import '../api/api.dart';

class TaskDescriptionForm extends StatefulWidget {
  final Task selectedTask;
  final GlobalKey<FormState> formKey;
  final Color textColor;

  TaskDescriptionForm(
      {Key key, this.selectedTask, this.formKey, this.textColor})
      : super(key: key);

  @override
  createState() => TaskDescriptionFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class TaskDescriptionFormState extends State<TaskDescriptionForm> {
  Task currentTask = new Task();

  List<ScheduleTime> availableTimes = [];
  int taskTime = 1;
  int priority = 1;
  ScheduleTime selectedRecTime;
  DateTime selectedTime;
  DateTime selectedDay;
  bool usingRecommended = false;
  bool timeHasBeenSelected = false;
  int timeSelectCount = 0; // this is getting bad im sorry

  List<DateTime> nextWeek;

  @override
  void initState() {
    currentTask = widget.selectedTask;
    if (widget.selectedTask.taskTime != null) {
      taskTime = widget.selectedTask.taskTime;
      timeHasBeenSelected = true;
    }

    if (widget.selectedTask.priority != null) {
      priority = widget.selectedTask.priority;
    }
    // currentTask.taskType = widget.selectedTask.taskType;
    updateTaskType(currentTask.taskType);
    generateWeek();
  }

  void submitForm() {
    currentTask.priority = priority;
    currentTask.taskTime = taskTime;

    if (timeHasBeenSelected) {
      if (usingRecommended) {
        currentTask.startTime = DateTime.parse(selectedRecTime.isoTime);
      } else {
        currentTask.startTime = DateTime(selectedDay.year, selectedDay.month,
            selectedDay.day, selectedTime.hour, selectedTime.minute, 0);
      }
    }
    

    if (currentTask.id == null) {
      // Post a task
      print("in post");
      postTask(currentTask, timeHasBeenSelected);
    } else {
      // Put a task
      print("not in post");
      putTaskPriority(currentTask);
      putTaskTime(currentTask);
    }
    Navigator.pop(context);
  }

  void updateTaskType(String type) {
    if (type != null) {
      setState(() {
        currentTask.taskType = type;
      });

      if (taskTime != null) {
        getTimes(type, taskTime);
      }
    }
  }

  void updateTaskTime(int time) {
    if (time != null) {
      if (currentTask.taskType != null) {
        getTimes(currentTask.taskType, taskTime);
      }
    }
    ;
  }

  void generateWeek() {
    List<DateTime> week = new List<DateTime>();
    for (int i = 0; i < 7; i++) {
      week.add(DateTime.now().add(Duration(days: i)));
    }
    print(week);
    setState(() {
      nextWeek = week;
    });
  }

  void getTimes(String type, int taskTime) async {
    Map<String, List<ScheduleTime>> recommendedTimes =
        await getRecommendedTimes(type, taskTime);

    setState(() {
      availableTimes = _getTimesFromRecommended(recommendedTimes);
    });
  }

  List<ScheduleTime> _getTimesFromRecommended(
      Map<String, List<ScheduleTime>> recommendedTimes) {
    List<ScheduleTime> times = new List<ScheduleTime>();

    if (currentTask.startTime != null) {
      times.add(
          ScheduleTime(completed: -1, isoTime: "Current Time", taskType: ""));
      ScheduleTime current = ScheduleTime(
          completed: 0,
          isoTime: currentTask.startTime.toIso8601String(),
          taskType: currentTask.taskType);
      times.add(current);
      setState(() {
        usingRecommended = true;
        selectedRecTime = current;
      });
    }

    String prevWeekday = "";
    recommendedTimes.forEach((weekday, listedTimes) {
      if (weekday != prevWeekday) {
        times.add(ScheduleTime(completed: -1, isoTime: weekday, taskType: ""));
        prevWeekday = weekday;
      }
      times.addAll(listedTimes);
    });

    return times;
  }

  _formatTime(DateTime startTime) {
    var formatter = new DateFormat('MMM dd,').add_jm();
    String formattedDate = formatter.format(startTime);
    return formattedDate; // 2016-01-25
  }

  _formatDay(DateTime startTime) {
    var formatter = new DateFormat('MMM d');
    String formattedDate = formatter.format(startTime);
    return formattedDate; // 2016-01-25
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Information",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6.0),
          TextFormField(
              // The validator receives the text that the user has entered.
              initialValue: widget.selectedTask.name,
              decoration: new InputDecoration(
                labelText: 'Name',
                focusColor: Color(0xfff88379),
              ),
              style: new TextStyle(color: widget.textColor),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String value) {
                currentTask.name = value;
              }),
          TextFormField(
              // The validator receives the text that the user has entered.
              initialValue: widget.selectedTask.description,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                labelText: 'Description',
                focusColor: Color(0xfff88379),
              ),
              style: new TextStyle(color: widget.textColor),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (String value) {
                currentTask.description = value;
              }),
          SizedBox(height: 22.0),
          Text(
            "Type",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 22.0),
          new Wrap(
            spacing: 14.0,
            runSpacing: 14.0,
            children: <Widget>[
              TypeTagButton(
                taskType: "academic",
                activated: currentTask.taskType == "academic",
                updateTaskType: updateTaskType,
              ),
              TypeTagButton(
                taskType: "work",
                activated: currentTask.taskType == "work",
                updateTaskType: updateTaskType,
              ),
              TypeTagButton(
                taskType: "exercise",
                activated: currentTask.taskType == "exercise",
                updateTaskType: updateTaskType,
              ),
              TypeTagButton(
                taskType: "meeting",
                activated: currentTask.taskType == "meeting",
                updateTaskType: updateTaskType,
              ),
              TypeTagButton(
                taskType: "personal",
                activated: currentTask.taskType == "personal",
                updateTaskType: updateTaskType,
              ),
            ],
          ),
          SizedBox(height: 22.0),
          (currentTask.id == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Location",
                      style: TextStyle(
                          color: widget.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 12.0),
                    Container(
                      constraints: BoxConstraints(maxWidth: 1350),
                      child: SearchMapPlaceWidget(
                        apiKey:
                            'AIzaSyAKlXJEHJl_LWnCoAZ6yzVZ4_ClomAS6QY', // YOUR GOOGLE MAPS API KEY
                        onSelected: (Place place) async {
                          print(place.description);
                          final geolocation = await place.geolocation;
                          print(geolocation);
                        },
                      ),
                    ),
                    SizedBox(height: 12.0),
                  ],
                )
              : SizedBox(height: 0.0)),
          Text(
            "Priority",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.0),
          DropdownButton<int>(
            isExpanded: true,
            hint: Text("Priority"),
            value: priority,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (int newValue) {
              setState(() {
                priority = newValue;
              });
            },
            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: 12.0),
          Text(
            "Task Length",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(
            height: 12.0,
          ),
          DropdownButton<int>(
            isExpanded: true,
            value: taskTime,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (int newValue) {
              setState(() {
                taskTime = newValue;
              });
              updateTaskTime(newValue);
            },
            items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child:
                    Text(value.toString() + (value == 1 ? " hour" : " hours")),
              );
            }).toList(),
          ),
          SizedBox(height: 12.0),
          Text(
            "Recommended Times",
            style: TextStyle(
                color: usingRecommended ? widget.textColor : Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          DropdownButton<ScheduleTime>(
            isExpanded: true,
            hint: Text('Time'),
            value: selectedRecTime,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (ScheduleTime newValue) {
              if (newValue.completed != -1) {
                setState(() {
                  selectedRecTime = newValue;
                  selectedTime = DateTime.parse(newValue.isoTime);
                  selectedDay = null;
                  usingRecommended = true;
                  timeHasBeenSelected = true;
                });
              }
            },
            items: availableTimes
                .map<DropdownMenuItem<ScheduleTime>>((ScheduleTime value) {
              return DropdownMenuItem<ScheduleTime>(
                value: value,
                child: Text(() {
                  if (value.completed != -1) {
                    return _formatTime(DateTime.parse(value.isoTime));
                  } else {
                    return value.isoTime;
                  }
                }(),
                    style: TextStyle(
                        color: () {
                          if (value.completed == 1) {
                            return Colors.green;
                          } else if (value.completed == -2) {
                            return Colors.red;
                          } else {
                            return Colors.black;
                          }
                        }(),
                        fontSize: 14,
                        fontWeight: value.completed == -1
                            ? FontWeight.w800
                            : FontWeight.w400)),
              );
            }).toList(),
          ),
          SizedBox(height: 12.0),
          Text(
            "Select a Day",
            style: TextStyle(
                color: !usingRecommended ? widget.textColor : Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.0),
          DropdownButton<DateTime>(
            isExpanded: true,
            value: selectedDay,
            hint: Text('Day'),
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            onChanged: (DateTime newValue) {
              setState(() {
                selectedDay = newValue.toUtc();
                selectedRecTime = null;
                usingRecommended = false;
                timeHasBeenSelected = true;
              });
            },
            items: nextWeek.map<DropdownMenuItem<DateTime>>((DateTime value) {
              return DropdownMenuItem<DateTime>(
                value: value,
                child: Text(_formatDay(value)),
              );
            }).toList(),
          ),
          SizedBox(height: 12.0),
          Text(
            "Select a Time",
            style: TextStyle(
                color: !usingRecommended ? widget.textColor : Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.0),
          TimePickerSpinner(
            is24HourMode: true,
            normalTextStyle: TextStyle(
                fontSize: 18,
                color: !usingRecommended ? Colors.black : Colors.grey),
            highlightedTextStyle: TextStyle(
                fontSize: 24,
                color: !usingRecommended ? Colors.black : Colors.grey),
            minutesInterval: 30,
            spacing: 30,
            itemHeight: 40,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                selectedTime = time.toUtc();
                usingRecommended = false;
                selectedRecTime = null;
                if (timeSelectCount > 0) {
                  timeHasBeenSelected = true;
                }
                timeSelectCount++;
              });
            },
          ),
        ],
      ),
    );
  }
}
