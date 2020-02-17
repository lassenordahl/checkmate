import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../detailPanels/taskDescription.dart';
import '../pageRouteBuilders/openCardRoute.dart';

import '../objects/Task.dart';

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [
    '123',
    '123445',
  ];

  // This will be called each time the + button is pressed
  void _addTodoItem() {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState(() {
      int index = _todoItems.length;
      // _todoItems.add('Item ' + index.toString());
    });
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new Column(
      children: <Widget>[for (var item in _todoItems) _buildTodoItem(item)],
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText) {
    return new Container(
      padding: EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0),
      child: GestureDetector(
        onTap: () {
          print("clicked ");
          Navigator.push(context, OpenCardRoute(page: TaskDescription()));
        },
        child: Hero(
          tag: 'TaskHero' + todoText,
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
                            "Work Out",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Time would go here",
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
