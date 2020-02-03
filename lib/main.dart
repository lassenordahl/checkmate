import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'todo.dart';
import 'completed.dart';
import 'addTask.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new TodoApp());
}

class TodoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'CS125 Project', home: new App());
  }
}

class App extends StatelessWidget {
  _getDateString() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM dd, yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate; // 2016-01-25
  }

  _test() {
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {
              // Call setState. This tells Flutter to rebuild the
              // UI with the changes.
              print("we're adding another one");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddTask()));
            },
            tooltip: 'Add Task',
            child: Icon(Icons.add),
            backgroundColor: Color(0xfff88379),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.deepPurple, Colors.deepPurple[700]])),
            child: RefreshIndicator(
                onRefresh: () {
                  Future<int> now = new Future(_test);
                  return now;
                },
                child: SingleChildScrollView(
                    child: Container(
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.blue, Colors.purple])),
                        child: Column(children: <Widget>[
                          new Container(
                            padding: EdgeInsets.only(
                              top: 64.0,
                              left: 32.0,
                              right: 32.0,
                              bottom: 32.0,
                            ),
                            child: new Row(
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Schedule",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _getDateString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ]),
                                // Column(
                                //   children: <Widget>[Text("hello")],
                                // )
                              ],
                            ),
                          ),
                          new Container(
                            padding: EdgeInsets.only(
                                left: 32.0, right: 32.0, bottom: 32.0),
                            child: new Row(
                              children: <Widget>[
                                Text(
                                  "Past Tasks",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          new CompletedList(),
                          new Container(
                            padding: EdgeInsets.only(
                              left: 32.0,
                              right: 32.0,
                              bottom: 32.0,
                            ),
                            child: new Row(
                              children: <Widget>[
                                Text(
                                  "Future Tasks",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                          new TodoList(),
                        ]))))));
  }
}