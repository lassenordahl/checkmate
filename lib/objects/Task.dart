class Task {
  final String name;
  final String description;
  final String task_type;
  final DateTime startTime;
  final DateTime endTime;
  final double lat;
  final double long;
  final int completed;

  Task(this.name, this.description, this.task_type, this.completed, this.startTime, this.endTime, this.lat, this.long);
}