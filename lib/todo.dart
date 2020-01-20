import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = ['Hello'];

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
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
      },
    );
  }

  // Build a single todo item
  Widget _buildTodoItem(String todoText) {
    // return new ListTile(
    //   title: Card(
    //     child: Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child:Text(todoText)
    //     )
    //   )
    // );
    return new CupertinoButton(
      padding: EdgeInsets.all(32.0),
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            new BoxShadow( 
              color: Colors.grey,
              // offset, the X,Y coordinates to offset the shadow
              offset: new Offset(0.0, 10.0), 
              // blurRadius, the higher the number the more smeared look 
              blurRadius: 15.0,
              spreadRadius: 1.0
            )
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Text(
            "Mindfulness",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600),
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
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text('Haha what!')
      // ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add task',
        child: new Icon(Icons.add)
      ),
    );
  }
}