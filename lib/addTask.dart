import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';

//import 'package:search_map_place/search_map_place.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './search_map_place/search_map_place.dart';
//import 'addTaskForm.dart';


class AddTask extends StatefulWidget {
  AddTask({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  _addTaskPostRequest(var data) async {
    //Read from disk
    final prefs = await SharedPreferences.getInstance();

    // set up POST request arguments
    String url = 'https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development/task';

    String accessToken = prefs.getString('access_token');
    print(accessToken);

    Map<String, String> headers = {"Content-type": "application/json", "Authorization": accessToken};

    var jsonBody = {};
    jsonBody["name"] = data['name'];
    jsonBody["description"] = data['description'];
    jsonBody["type"] = data['type'];
    jsonBody["start_time"] = '2020-03-06T02:09:36Z';//data['start_time'];
    jsonBody["end_time"] = '2020-03-06T02:09:56Z';//data['end_time'];
    jsonBody["long"] = data['long'];
    jsonBody["lat"] = data['lat'];
    jsonBody["priority"] = '2';
    String bodyJson = json.encode(jsonBody);
    
    print(bodyJson);

    // make POST request
    Response response = await post(url, headers: headers, body: bodyJson);
    
    // check the status code for the result
    int statusCode = response.statusCode;
    print("Status Code");
    print(statusCode);
    
    // this API passes back the id of the new item added to the body
    print( response.body );
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }
  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    List<String> _startTimes = <String>['','8:00am', '8:30am', '9:00am', '9:30am'];//, '10:00am', '10:30am','11:00am', '11:30pm', '12pm', '12:30pm', '1:00pm', '1:30pm', '2:00pm'];
    String _startTime = '';
    String _endTime = '';
    String _geoLocation = '';
    final Map<String, dynamic> formData = {'name': null, 'description': null,
      'type': null, 'start_time':'-1', 'end_time':'-1', 'long':null, 'lat':null};
    
    return new Scaffold(
        body: Container(

            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.cyan[400], Colors.blue[500]]
                  )
                ),
            padding: EdgeInsets.only(
                      top: 64.0,
                      left: 32.0,
                      right: 32.0,
                      //bottom: 32.0,
                    ),
            child: Form( 
              key: _formKey, 
              child: ListView(
                children: <Widget>[
                  //Title -------------------------------------------------------
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Add Task",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                      ),

                  //TASK NAME -------------------------------------------------------
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: new InputDecoration(
                      labelText: 'Task name',
                      focusColor: Color(0xfff88379),
                    ),

                    style: new TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      formData['name'] = value;
                    }
                  ),

                  //TASK Description -------------------------------------------------------
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: new InputDecoration(
                      labelText: 'Task Description',
                      focusColor: Color(0xfff88379),
                    ),

                    style: new TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      formData['description'] = value;
                    }
                  ),

                  //Type of Task -------------------------------------------------------
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    decoration: new InputDecoration(
                      labelText: 'Type of Task',
                      focusColor: Color(0xfff88379),
                    ),

                    style: new TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      formData['type'] = value;
                    }
                  ),

                  //Start Time -------------------------------------------------------
                  /*new FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.schedule),
                            labelText: 'Start Times',
                          ),
                          isEmpty: _startTime == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: _startTime,
                              isDense: true,
                              onChanged: (String newValue) {
                                _startTime = newValue;
                                formData['start_time'] = _startTime;
                              },
                              items: _startTimes.map((String value) {
                                return new DropdownMenuItem(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),

                  //End Time -------------------------------------------------------
                  new FormField(
                      builder: (FormFieldState state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            icon: const Icon(Icons.schedule),
                            labelText: 'End Times',
                          ),
                          isEmpty: _endTime == '',
                          child: new DropdownButtonHideUnderline(
                            child: new DropdownButton(
                              value: _endTime,
                              isDense: true,
                              onChanged: (String newValue) {
                                formData['end_time'] = newValue;
                                
                                  _endTime = newValue;
                                
                                
                              },
                              items: _startTimes.map((String value) {
                                return new DropdownMenuItem(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },                     
                    ),*/

                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),

                  //Location -------------------------------------------------------
                  new SearchMapPlaceWidget(
                              apiKey: 'AIzaSyAKlXJEHJl_LWnCoAZ6yzVZ4_ClomAS6QY',// YOUR GOOGLE MAPS API KEY
                              onSelected: (Place place) async {
                                  print(place.description);
                                  final geolocation = await place.geolocation;
                                  
                                  print(geolocation);
                                  print(geolocation.coordinates);
                                  _geoLocation = geolocation.coordinates.toString();                                 
                            },
                            
                          ),
                        
                              
                              
                  
                  //Submit Task -------------------------------------------------------
                  new Container(
                    padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                    child: new RaisedButton(
                      //color: Colors.white,
                      onPressed: () {
                        
                        //Longitude, Latitude
                        String s = _geoLocation;
                        String lat = s.substring(7, s.indexOf(','));
                        String lng = s.substring(s.indexOf(',') + 2, s.indexOf(')'));
                        
                        print(lat);
                        print(lng);
                        formData['lat'] = lat;
                        formData['long'] = lng;

                        print('Submitting form');
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save(); //onSaved is called!
                          _addTaskPostRequest(formData);
                        }
                      },
                      child: Text("Submit Task", 
                        style: TextStyle(
                          color: Color(0xffFFFFFF),
                        ),),
                  )),
                  
                  //End of Form -------------------------------------------------------------
                ])
                  
                ]
            )
            )
            )
            );
  }
}
