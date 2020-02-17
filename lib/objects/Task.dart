class Task {
  final int id;
  final String name;
  final String description;
  final String taskType;
  final DateTime startTime;
  final DateTime endTime;
  final double lat;
  final double long;
  final int completed;

  Task(this.id, this.name, this.description, this.taskType, this.completed, this.startTime, this.endTime, this.lat, this.long);
}