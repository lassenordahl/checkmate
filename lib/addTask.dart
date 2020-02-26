import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';

import 'package:search_map_place/search_map_place.dart';

import 'addTaskForm.dart';


class AddTask extends StatefulWidget {
  AddTask({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  String _value;
  String _value2;

  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        body: Container(

            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.cyan[400], Colors.blue[500]]
                  )
                ),
            child: Column(children: <Widget>[
              new Container(
                  padding: EdgeInsets.only(
                    top: 64.0,
                    left: 32.0,
                    right: 32.0,
                    bottom: 32.0,
                  ),
                  child: new Row(children: <Widget>[
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

                          new AddTaskForm(),

                        SearchMapPlaceWidget(
                            apiKey: 'AIzaSyAKlXJEHJl_LWnCoAZ6yzVZ4_ClomAS6QY',// YOUR GOOGLE MAPS API KEY
                            onSelected: (Place place) async {
                                print(place.description);
                                final geolocation = await place.geolocation;
                                print(geolocation);
                            },
                          )
                          ,
                          
                          
                          
                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('Monday'),
                                value: 'Monday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Tuesday'),
                                value: 'Tuesday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Wednesday'),
                                value: 'Wednesday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Thursday'),
                                value: 'Thursday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Friday'),
                                value: 'Friday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Saturday'),
                                value: 'Saturday',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('Sunday'),
                                value: 'Sunday',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                _value = value;
                              });
                            },
                            hint: Text('Select Item'),
                            value: _value,
                          ),

                          DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(
                                child: Text('1:30pm - 2:00pm'),
                                value: '1:30pm - 2:00pm',
                              ),
                              DropdownMenuItem<String>(
                                child: Text('2:30pm - 3:00pm'),
                                value: '2:30pm - 3:00pm',
                              ),
                            ],
                            onChanged: (String value) {
                              setState(() {
                                _value2 = value;
                              });
                            },
                            hint: Text('Avaliable times based on day'),
                            value: _value2,
                          ),

                          /*TextFormField(
                              //controller: _controller,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                  WhitelistingTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  labelText:"whatever you want", 
                                  hintText: "whatever you want",
                                  icon: Icon(Icons.phone_iphone)
                              )
                          ),*/

                          //Submits the information- Connect to backend
                          Center(
                          child: RaisedButton(
                            color: Colors.white,
                            onPressed: null,
                            child: Text("Submit Task", 
                              style:TextStyle(
                                color: Color(0xffFFFFFF),
                              ),),
                            ),
                          ),

                          

                        ])
                  ]))
            ])));
  }
}
