import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../objects/Task.dart';
import '../objects/ScheduleTime.dart';

String awsUrl = "https://bttmns45mb.execute-api.us-west-2.amazonaws.com";
String knnUrl = "https://checkmate-data-backend.herokuapp.com/api";
String devUrl = "localhost:5000/api";
String userId = "1";

String authorizationHeader = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlFqRTJNemN5TWpKRE1ERTFSRVE0UXpRME1UQkJOVVpDUlRreU1ESXhSVVpFTnpFd09EVTFOdyJ9.eyJpc3MiOiJodHRwczovL2xlYXJuaW5nY2FsZW5kYXItZGV2ZWxvcG1lbnQuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTExMDEzNzc2NjY0NjI2MjA1OTY2IiwiYXVkIjpbImh0dHBzOi8vYnR0bW5zNDVtYi5leGVjdXRlLWFwaS51cy13ZXN0LTIuYW1hem9uYXdzLmNvbS9kZXZlbG9wbWVudCIsImh0dHBzOi8vbGVhcm5pbmdjYWxlbmRhci1kZXZlbG9wbWVudC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTgzNjQzMTA4LCJleHAiOjE1ODM3Mjk1MDgsImF6cCI6Ik5Ib1VBUnY3S0tkTzJWY0N1ZDNPV3pwdlo1MmIxNm04Iiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyJ9.dJzf1IMNoXX7fL2myMjl-WcNo41mnNv38C4O6Xz7RS5Wij6cPl1mHxdJ-yJEmcnWASbHi61Hs3k5HpCZOklxlabDU8kJ3_wNtO7z7o3sXQ_zTx7Tn_YJYYLBVztu-06jJ8KSe05mfgiG6JZ8H_uDf_TS2egtrym_CrvPWVr-ON8Z9KT6qEjibNeeTFG0PXEMnuw7Ur_maR4PAg9h91xaOBEEKnQ7awMRz8k-6FfDYAmMUjDrgCdDcmQsclxnHKFOiNRuTE0A_i0qDJFXvar0CX_JfG4VuqZ2dgQ6IC9GjnJ70I9dX-KGhyHK3_Gm1jwGdBAQixYl_tCsYztS93V4Pw";

Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
       'Authorization': authorizationHeader
     };


Future<Map<String,List<ScheduleTime>>> getRecommendedTimes(String taskType) async {
  final response =
      await http.get(knnUrl + '/1/times/recommended?task_type=' + taskType, headers: requestHeaders);

  if (response.statusCode == 200) {
    Map<String, List<ScheduleTime>> returnMap = new Map<String, List<ScheduleTime>>();
    json.decode(response.body).forEach((item, value) {
      returnMap[item] = value.map<ScheduleTime>((obj) => ScheduleTime.fromJson(obj)).toList();
    });
    return returnMap;
  } else {
    print(response);
    print(response.statusCode);
    throw Exception("You done fucked up you dumb ho");
  }
}


Future<List<ScheduleTime>> getAnnotatedTimes(String taskType) async {
  final response =
      await http.get(knnUrl + '/1/times?task_type=' + taskType, headers: requestHeaders);

  if (response.statusCode == 200) {
    return json.decode(response.body).map<ScheduleTime>((time) => ScheduleTime.fromJson(time)).toList();
  } else {
    throw Exception("You done fucked up you dumb ho");
  }
}


Future<List<Task>> getPast() async {
  final response =
      await http.get(awsUrl + '/development/task/past?completed=-1', headers: requestHeaders);

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'].map<Task>((task) => Task.fromJson(task)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get past task');
  }
}

Future<List<Task>> getScheduled() async {
  final response =
      await http.get(awsUrl + '/development/task/future?completed=-1', headers: requestHeaders);

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'].map<Task>((task) => Task.fromJson(task)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get scheduled task');
  }
}


Future<List<Task>> getUnscheduled() async {
  final response =
      await http.get(awsUrl + '/development/task/unscheduled?completed=-1', headers: requestHeaders);

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'].map<Task>((task) => Task.fromJson(task)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get unscheduled task');
  }
}

void putCompleted(String taskId, int completed, Function getTasks) async {
  String jsonObject = '{"task_id": "'+  taskId + '", "completed": "' + completed.toString() + '"}';

  final response =
      await http.put('https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development/task/completed', headers: requestHeaders, body: jsonObject);

  if (response.statusCode == 200) {
    putCompletedKNN(Task.fromJson(json.decode(response.body)['data']));
    getTasks();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to update completion');
  }
}

void putTask(Task task) async {
  // String jsonObject = '{"task_id": "'+  taskId + '", "completed": "' + completed.toString() + '"}';

  print(json.encode(task.toJson()));

  // final response =
  //     await http.put('https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development/task/completed', headers: requestHeaders, body: jsonObject);

  // if (response.statusCode == 200) {
  //   putCompletedKNN(Task.fromJson(json.decode(response.body)['data']));
  //   getTasks();
  // } else {
  //   // If the server did not return a 200 OK response, then throw an exception.
  //   throw Exception('Failed to update completion');
  // }
}

void putCompletedKNN(Task completedTask) async {
  print(completedTask);

  print(completedTask.startTime.weekday);

  Map<String, String> queryParams = {
    "task_type": completedTask.taskType,
    "day_of_week": getDayOfWeek(completedTask.startTime.weekday - 1),
    "time_of_day": 1.toString(),
    "completed": completedTask.completed.toString(),
  };

  String queryString = "?task_type=" + queryParams["task_type"] + "&day_of_week=" + queryParams["day_of_week"] +
                       "&time_of_day=" + queryParams["time_of_day"] + "&completed=" + queryParams["completed"];

  print(knnUrl + "/" + userId + "/task" + queryString);

  final response = await http.post(knnUrl + "/" + userId + "/task" + queryString);

  if (response.statusCode == 200) {
    print("Successfully added to KNN");
  } else {
    throw Exception("Failed to add to KNN");
  }
}

String getDayOfWeek(int weekday) {
  if (weekday == 0) {
    return "monday";
  } else if (weekday == 1) {
    return "tuesday";
  } else if (weekday == 2) {
    return "wednesday";
  } else if (weekday == 3) {
    return "thursday";
  } else if (weekday == 4) {
    return "friday";
  } else if (weekday == 5) {
    return "saturday";
  } else if (weekday == 6) {
    return "sunday";
  }
}