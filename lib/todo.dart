import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [
    'Hello',
    'Hello',
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
    return new ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText) {

    return new CupertinoButton(
      padding: EdgeInsets.only(bottom: 32.0, left: 32.0, right: 32.0),
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
          margin: EdgeInsets.all(16.0),
          child: Text(
            "Work Out",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      onPressed: () {
        print("we clicked the card with text" + todoText);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTodoList();
  }
}
