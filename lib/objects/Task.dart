class Task {
  String id;
  String name;
  String description;
  String taskType;
  DateTime startTime;
  DateTime endTime;
  double lat;
  double long;
  int completed;
  int priority;
  int taskTime;

  Task({this.id, this.name, this.description, this.taskType, this.completed, this.startTime, this.endTime, this.lat, this.long, this.priority, this.taskTime});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['task_id'], 
      name: json['name'] , 
      description: json['description'], 
      taskType: json['type'], 
      completed: json['completed'], 
      startTime: json['start_time'] == "-1" ? DateTime.now() : DateTime.parse(json['start_time']), 
      endTime: json['end_time'] == null ? DateTime.now() : DateTime.parse(json['end_time']), 
      lat: double.parse(json['lat']), 
      long: double.parse(json['long']),
      taskTime: json['task_time'] == null ? 1 : json['task_time'],
      priority: json['priority'] == null ? 5 : json['priority']
    );
  }

  Map<String, dynamic> toJson(bool newTask) {
    Map<String, dynamic> returnMap = {
      'name': name,
      'description': description,
      'type': taskType,
      'start_time': startTime.toIso8601String(),
      'lat': "33",
      'long': "33",
      'task_time': taskTime,
      'priority': priority,
    };

    if (!newTask) {
      returnMap['task_id'] = id;
    }

    return returnMap;
  }
  
}