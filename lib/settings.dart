import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'changeAddressForm.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.cyan[400], Colors.blue[500]])),
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
                              "Settings",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          new ChangeAddressForm()
                        ])
                  ]))
            ])));
  }
}
