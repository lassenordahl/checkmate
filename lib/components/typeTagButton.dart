import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TypeTagButton extends StatefulWidget {
  final String taskType;
  final bool activated;
  final Function updateTaskType;

  TypeTagButton({Key key, this.taskType, this.activated, this.updateTaskType}) : super(key: key);

  @override
  createState() => new TypeTagButtonState();
}

class TypeTagButtonState extends State<TypeTagButton> {

  // int _activated = widget.activated;

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
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.updateTaskType(widget.taskType);
          // widget.activated = widget.activated == 0 ? 1 : 0;
        });
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 100, maxHeight: 30),
        decoration: BoxDecoration(
          color:
              !widget.activated ? Colors.white : _getColor(widget.taskType),
          border: Border.all(
            color: !widget.activated
                ? _getColor(widget.taskType)
                : Colors.white,
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
                widget.taskType,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: !widget.activated
                      ? _getColor(widget.taskType)
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
