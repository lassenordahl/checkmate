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

  Task({this.id, this.name, this.description, this.taskType, this.completed, this.startTime, this.endTime, this.lat, this.long});

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
      long: double.parse(json['long'])
    );
  }
}