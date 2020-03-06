import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TaskTypeTag extends StatelessWidget {
  final String taskType;

  TaskTypeTag({Key key, this.taskType});

  Color _getColor(String type) {
    if (type == "academic") {
      return Colors.deepPurple[700];
    } else if (type == "work") {
      return Colors.red[700];
    } else if (type == "exercise") {
      return Colors.deepOrange[600];
    } else if (type == "meeting") {
      return Colors.green[600];
    } else if (type == "personal") {
      return Colors.cyan[700];
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 100, maxHeight: 30),
      decoration: BoxDecoration(
        border: Border.all(
          color: _getColor(taskType),
        ),
        borderRadius: new BorderRadius.all(
          new Radius.circular(5.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 3.0,
              bottom: 3.0,
              left: 3.0,
              right: 3.0,
            ),
            child: Text(
              taskType,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _getColor(taskType),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
