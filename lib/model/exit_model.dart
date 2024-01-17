// To parse this JSON data, do
//
//     final exit = exitFromJson(jsonString);

import 'dart:convert';

Exit exitFromJson(String str) => Exit.fromJson(json.decode(str));

String exitToJson(Exit data) => json.encode(data.toJson());

class Exit {
  int date;
  int month;
  int year;
  String time;
  double latitude;
  double longitude;
  String exitNote;

  Exit({
    required this.date,
    required this.month,
    required this.year,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.exitNote,
  });

  factory Exit.fromJson(Map<String, dynamic> json) => Exit(
        date: json["date"],
        month: json["month"],
        year: json["year"],
        time: json["time"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        exitNote: json["exit_note"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "month": month,
        "year": year,
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "exit_note": exitNote,
      };
}
