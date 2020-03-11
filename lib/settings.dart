import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// This is awful, but I'm running out of time
import './search_map_place_2/search_map_place.dart';
import './api/api.dart';
import './objects/Calendar.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  List<Calendar> calendars = new List<Calendar>();

  @override
  initState() {
    _getCalendars();
  }

  void _getCalendars() async {
    List<Calendar> newCalendars = await getCalendar();
    setState(() {
      calendars = newCalendars;
    });
    print(newCalendars);
  }

  void _updateCalendar(String id, bool selected) {
    putCalendar(id, selected);
  }

  Widget _buildCalendarItem(Calendar calendar) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Checkbox goes here
              Checkbox(
                checkColor: Colors.cyan,  // color of tick Mark
                activeColor: Colors.white,
                value: calendar.selected,
                onChanged: (bool value) {
                  setState(() {
                    calendar.selected = value;
                  });
                  _updateCalendar(calendar.id, value);
                },
              ),
            ],
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                calendar.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6.0),
              Text(
                "Timezone: " + calendar.timezone,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              // SizedBox(height: 16.0),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: <Widget>[for (var item in calendars) _buildCalendarItem(item)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () {},
        child: Icon(Icons.save),
        backgroundColor: Color(0xfff88379),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.cyan[400], Colors.blue[500]])),
        child: Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(
                top: 64.0,
                left: 32.0,
                right: 32.0,
                bottom: 32.0,
              ),
              child: Column(
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
                  SizedBox(height: 12.0),
                  Text(
                    "Home Address",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                      constraints: BoxConstraints(maxWidth: 1350),
                      child: SearchMapPlaceWidget(
                        apiKey:
                            'AIzaSyAKlXJEHJl_LWnCoAZ6yzVZ4_ClomAS6QY', // YOUR GOOGLE MAPS API KEY
                        onSelected: (Place place) async {
                          print(place.description);
                          final geolocation = await place.geolocation;
                          print(geolocation);
                        },
                      ),
                    ),
                  SizedBox(height: 12.0),
                  Text(
                    "Calendars",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 12.0),
                  _buildCalendar()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
