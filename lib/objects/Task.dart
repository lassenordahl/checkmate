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

  Task({this.id, this.name, this.description, this.taskType, this.completed, this.startTime, this.endTime, this.lat, this.long, this.priority});

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
      // priority: json['priority'] == null ? 5 : json['priority']
      priority: 1
    );
  }

  Map<String, dynamic> toJson() => 
  {
      'id': id,
      'name': name,
      'description': description,
      'taskType': taskType,
      'startTime': startTime.toIso8601String(),
      'lat': lat,
      'long': long,
      'completed': completed,
      'priority': priority,
  };
}