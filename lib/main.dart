import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'taskLists/scheduledTasks.dart';
import 'taskLists/limboTasks.dart';
import 'taskLists/unscheduledTasks.dart';
import 'addTask.dart';
import 'settings.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(new Login());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkmate',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key});

  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  String _filter = "";
  final GlobalKey<LimboTasksState> _limboState = GlobalKey<LimboTasksState>();
  final GlobalKey<ScheduledTasksState> _scheduledState = GlobalKey<ScheduledTasksState>();
  final GlobalKey<UnscheduledTasksState> _unscheduledState = GlobalKey<UnscheduledTasksState>();

  _getDateString() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM dd, yyyy');
    String formattedDate = formatter.format(now);
    return formattedDate; // 2016-01-25
  }

  _changeFilter(value) {
    setState(() {
      _filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: Padding(
          padding: EdgeInsets.all(0.0),
          child: SpeedDial(
              overlayColor: Colors.white,
              overlayOpacity: 0.6,
              tooltip: 'Add Task',
              child: Icon(Icons.menu),
              backgroundColor: Colors.grey[800],
              // backgroundColor: Color(0xfff88379),
              children: [
                SpeedDialChild(
                  child: Icon(Icons.settings),
                  backgroundColor: Colors.grey[800],
                  label: "Settings",
                  onTap: () {
                    // Call setState. This tells Flutter to rebuild the
                    // UI with the changes.
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
                SpeedDialChild(
                  backgroundColor: Colors.grey[800],
                  child: Icon(Icons.add),
                  label: "Create Task",
                  onTap: () {
                    // Call setState. This tells Flutter to rebuild the
                    // UI with the changes.
                    print("we're adding another one");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddTask()));
                  },
                ),
              ])
          // child: FloatingActionButton(
          //   onPressed: () {
          //     // Call setState. This tells Flutter to rebuild the
          //     // UI with the changes.
          //     print("we're adding another one");
          //     Navigator.push(
          //         context, MaterialPageRoute(builder: (context) => AddTask()));
          //   },
          //   tooltip: 'Add Task',
          //   child: Icon(Icons.add),
          //   backgroundColor: Color(0xfff88379),
          // ),
          ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.cyan[400], Colors.blue[500]],
          ),
        ),
        // colors: [Colors.deepPurple, Colors.deepPurple[700]])),
        child: RefreshIndicator(
          onRefresh: () {
            // Future<int> now = new Future(_test());
            // return now;
            final future = Future.delayed(const Duration(seconds: 2), () {
              _limboState.currentState.initState();
              _scheduledState.currentState.initState();
              _unscheduledState.currentState.initState();
              print("re-initialized the states");
            });
            return future;
          },
          child: SingleChildScrollView(
            child: Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.blue, Colors.purple])),
              child: Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(
                      top: 64.0,
                      left: 32.0,
                      right: 32.0,
                      bottom: 6.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // RaisedButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => Login()));
                        //   },
                        //   child: const Text('Login',
                        //       style: TextStyle(fontSize: 20)),
                        // ),
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
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: TextField(
                              style: new TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                _changeFilter(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding:
                        EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "Limbo Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  new LimboTasks(key: _limboState, filter: _filter),
                  new Container(
                    padding: EdgeInsets.only(
                      left: 32.0,
                      right: 32.0,
                      bottom: 32.0,
                    ),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "Scheduled Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  new ScheduledTasks(key: _scheduledState, filter: _filter),
                  new Container(
                    padding: EdgeInsets.only(
                      left: 32.0,
                      right: 32.0,
                      bottom: 32.0,
                    ),
                    child: new Row(
                      children: <Widget>[
                        Text(
                          "Unscheduled Tasks",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  new UnscheduledTasks(key: _unscheduledState,filter: _filter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
