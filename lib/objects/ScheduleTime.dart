class ScheduleTime {
  int completed;
  String isoTime;
  String taskType;

  ScheduleTime({this.completed, this.isoTime, this.taskType});

  factory ScheduleTime.fromJson(Map<String, dynamic> json) {
    return ScheduleTime(
      completed: json['completed'], 
      isoTime: json['iso_time'] , 
      taskType: json['type'], 
    );
  }
}