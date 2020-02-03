import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException, SystemNavigator;

void main() => runApp(Login());

class Login extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}




class _MyHomePageState extends State<MyHomePage> {

  //String tempUri = "Google Login";


  _launchURL() async {
    const url = 'https://learningcalendar-development.auth0.com'
    +'/authorize?response_type=code'
    + '&client_id=NHoUARv7KKdO2VcCud3OWzpvZ52b16m8'
    + '&connection=google-oauth2'
    + '&redirect_uri=deeplink://testing';
    if (await canLaunch(url)) {
      await launch(url);
      SystemNavigator.pop();
    } else {
      throw 'Could not launch $url';
    }
  }

  _base64URLEncode(str) {
    var regexPlus = new RegExp(r'\+');
    var regexBackslash = new RegExp(r'/');
    var regexEqual = new RegExp(r'=');

    return base64Url.encode(str)
        .replaceAll(regexPlus, '-')
        .replaceAll(regexBackslash, '_')
        .replaceAll(regexEqual, '');
  }

  _generateCodeVerifier() {
    var random = Random.secure();
    var values = List<int>.generate(32, (i) => random.nextInt(256));

    return _base64URLEncode(values);
  }

  _generateCodeChallenge(str) {
    return _base64URLEncode(sha256.convert(ascii.encode(str)).bytes);
  }

  String _link;
  //StreamSubscription _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String initialLink = await getInitialLink();
      print(initialLink);
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      setState(() {
        _link = initialLink;
      });
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Center(
              child: RaisedButton(
              onPressed: _launchURL,
              child: Text("Google Login"),
              ),
            ),
            Text(_link ?? ""),
          ]
        ),
      ),
    );
  }
}