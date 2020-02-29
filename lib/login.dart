import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException, SystemNavigator;

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() => runApp(Login());

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

  var verifier;

  _launchURL() async {
    verifier = _generateCodeVerifier();
    //Store verifier on disk
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('verifier', verifier);

    var codeChallenge = _generateCodeChallenge(verifier);
    print("Code Verifier:" + verifier);

    var url = 'https://learningcalendar-development.auth0.com' +
        '/authorize?response_type=code' +
        '&client_id=NHoUARv7KKdO2VcCud3OWzpvZ52b16m8' +
        '&audience=https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development' +
        // '&scope=offline_access openid profile' +
        '&scope=profile' +
        '&access_type=offline' +
        '&connection=google-oauth2' +
        '&code_challenge_method=S256' +
        '&code_challenge=' +
        codeChallenge +
        '&redirect_uri=ucicm://uci.checkmate.deeplink';
    print(url);

    try {
      String initialLink = await getInitialLink();
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      print('initial link');
      print(initialLink);
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }

    if (await canLaunch(url)) {
      print('was able to launch');
      await launch(url);
      print("url hello");
      // SystemNavigator.pop();
    } else {
      throw 'Could not launch $url';
    }
  }

  _base64URLEncode(str) {
    var regexPlus = new RegExp(r'\+');
    var regexBackslash = new RegExp(r'/');
    var regexEqual = new RegExp(r'=');

    return base64Url
        .encode(str)
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
  String _authCode;
  String _authToken;
  String _authTokenResponse;
  StreamSubscription _sub;

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
      if (_link != null) {
        String code = _link.split("=")[1];
        _authCode = code;
        print(code); // E4t8E7TIwhIK97wr
        _exchangeAuthForToken();
      }
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }

    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      // Use the uri and warn the user, if it is not correct
      setState(() {
        _link = uri.toString();
      });
      if (_link != null) {
        String code = _link.split("=")[1];
        _authCode = code;
        _exchangeAuthForToken();
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  //Trade Auth code for token
  _exchangeAuthForToken() async {
    //Read from disk
    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return 0.
    var verifierDisk = prefs.getString('verifier');

    print('verfier:');
    print(verifierDisk);
    print('##################');
    var codeChallenge = _generateCodeChallenge(verifierDisk);

    /*
      * @apiParam {String} type Whether the token is for "login" or "refresh".
      * @apiParam {String} client_id Client ID for the user pool.
      * @apiParam {String} refresh_token Refresh token. Only required for the "refresh" type.
      * @apiParam {String} code Code from the OAuth2 provider. Required only for "login" type.
      * @apiParam {String} code_verifier Code verifier for login. Required only for "login" type.
      * @apiParam {String} redirect_uri Redirects to this location once completed. Required only for "login" type.
    */

    // set up POST request arguments
    String url =
        'https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development/auth/tokens';
    /*+'?type=login'
    + '&client_id=NHoUARv7KKdO2VcCud3OWzpvZ52b16m8'
    + '&code=' + _authCode
    + '&code_challenge=' + codeChallenge
    + '&redirect_uri=deeplink://testing';*/

    print(url);

    Map<String, String> headers = {"Content-type": "application/json"};
    var jsonBody = {};
    jsonBody["type"] = "login";
    jsonBody["client_id"] = "NHoUARv7KKdO2VcCud3OWzpvZ52b16m8";
    jsonBody["code"] = _authCode;
    jsonBody["code_challenge"] = codeChallenge;
    jsonBody["redirect_uri"] = "deeplink://testing";
    String bodyJson = json.encode(jsonBody);
    /*Map<String, String> json = {"type": "login", "client_id": "NHoUARv7KKdO2VcCud3OWzpvZ52b16m8",
    "code": _authCode, "code_challenge": codeChallenge, "redirect_uri":"deeplink://testing"
    };*/
    /*String json = '{"type": "login", "client_id": "NHoUARv7KKdO2VcCud3OWzpvZ52b16m8", "code": "' 
    + _authCode + '", "code_challenge": "'+ codeChallenge + '", "redirect_uri": "deeplink://testing"}';*/

    // make POST request
    Response response = await post(url, headers: headers, body: bodyJson);

    // check the status code for the result
    //int statusCode = response.statusCode;

    // this API passes back the id of the new item added to the body
    String body = response.body;
    print(body);
    //_authTokenResponse = body;
    //var parsedJson = json.decode(response.body);
    //_authToken = parsedJson['data']['access_token'];

    //Get Authtoken from repsponse
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 64.0,
        left: 32.0,
        right: 32.0,
        bottom: 32.0,
      ),
      child: Center(
        child: Column(children: <Widget>[
          Center(
            child: RaisedButton(
              onPressed: _launchURL,
              child: Text("Google Login"),
            ),
          ),
          Text(_link ?? ""),
          Text(_authCode ?? ""),
          Text(_authToken ?? ""),
        ]),
      ),
    );
  }
}
