// To parse this JSON data, do
//
//     final statistic = statisticFromJson(jsonString);

import 'dart:convert';

Statistic statisticFromJson(String str) => Statistic.fromJson(json.decode(str));

String statisticToJson(Statistic data) => json.encode(data.toJson());

class Statistic {
  String name;
  String position;
  // double presencePercent;
  // double absentPercent;
  double onTimePercent;
  double latePercent;

  Statistic({
    required this.name,
    required this.position,
    // required this.presencePercent,
    // required this.absentPercent,
    required this.onTimePercent,
    required this.latePercent,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        name: json["name"],
        position: json["position"],
        // presencePercent: json["presence_percent"]?.toDouble(),
        // absentPercent: json["absent_percent"]?.toDouble(),
        onTimePercent: json["on_time_percent"]?.toDouble(),
        latePercent: json["late_percent"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        // "presence_percent": presencePercent,
        // "absent_percent": absentPercent,
        "on_time_percent": onTimePercent,
        "late_percent": latePercent,
      };
}
