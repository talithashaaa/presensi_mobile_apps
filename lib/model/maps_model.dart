// To parse this JSON data, do
//
//     final entry = entryFromJson(jsonString);

import 'dart:convert';

Entry entryFromJson(String str) => Entry.fromJson(json.decode(str));

String entryToJson(Entry data) => json.encode(data.toJson());

class Entry {
  String day;
  int date;
  int month;
  int year;
  String time;
  double latitude;
  double longitude;
  String status;
  String entryNote;

  Entry({
    required this.day,
    required this.date,
    required this.month,
    required this.year,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.entryNote,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        day: json["day"],
        date: json["date"],
        month: json["month"],
        year: json["year"],
        time: json["time"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        status: json["status"],
        entryNote: json["entry_note"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "date": date,
        "month": month,
        "year": year,
        "time": time,
        "latitude": latitude,
        "longitude": longitude,
        "status": status,
        "entry_note": entryNote,
      };
}
