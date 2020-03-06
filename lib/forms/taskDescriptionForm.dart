// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../components/typeTagButton.dart';
import '../objects/Task.dart';
import '../search_map_place/search_map_place.dart';
// import 'package:search_map_place/search_map_place.dart';

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
  // currentTask.taskType = widget.selectedTask.taskType;

  int placeholderPriority = 1;

  @override
  void initState() {
    currentTask.taskType = widget.selectedTask.taskType;
  }

  void submitForm() {
    print("FORM INFORMATION");
    print(currentTask.name);
    print(currentTask.description);
  }

  void updateTaskType(String type) {
    setState(() {
      currentTask.taskType = type;
    });
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
          SizedBox(height: 12.0),
          TextFormField(
              // The validator receives the text that the user has entered.
              initialValue: widget.selectedTask.name,
              decoration: new InputDecoration(
                hintText: 'Name',
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
          Text(
            "Location",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10.0),
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
          SizedBox(height: 18.0),
          Text(
            "Task Length",
            style: TextStyle(
                color: widget.textColor,
                fontSize: 22,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12.0),
          DropdownButton<int>(
            isExpanded: true,
            value: placeholderPriority,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            // elevation: 16,
            // underline: Container(
            //   height: 2,
            //   color: Colors.deepPurpleAccent,
            // ),
            onChanged: (int newValue) {
              setState(() {
                placeholderPriority = newValue;
              });
            },
            items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          SizedBox(height: 18.0),
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
            value: placeholderPriority,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            // elevation: 16,
            // underline: Container(
            //   height: 2,
            //   color: Colors.deepPurpleAccent,
            // ),
            onChanged: (int newValue) {
              setState(() {
                placeholderPriority = newValue;
              });
            },
            items: <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
