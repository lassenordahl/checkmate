class Calendar {
  String id;
  String name;
  String timezone;
  bool selected;

  Calendar({this.id, this.name, this.timezone, this.selected});

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      id: json['id'], 
      name: json['name'] , 
      timezone: json['timezone'], 
      selected: json['selected']
    );
  }
}