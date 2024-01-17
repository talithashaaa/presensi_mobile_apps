// To parse this JSON data, do
//
//     final history = historyFromJson(jsonString);

import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  String name;
  String position;
  List<HistoryList> historyList;

  History({
    required this.name,
    required this.position,
    required this.historyList,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        name: json["name"],
        position: json["position"],
        historyList: List<HistoryList>.from(
            json["history_list"].map((x) => HistoryList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "history_list": List<dynamic>.from(historyList.map((x) => x.toJson())),
      };
}

class HistoryList {
  String dayDate;
  String entryTime;
  String exitTime;
  String status;

  HistoryList({
    required this.dayDate,
    required this.entryTime,
    required this.exitTime,
    required this.status,
  });

  factory HistoryList.fromJson(Map<String, dynamic> json) => HistoryList(
        dayDate: json["day_date"],
        entryTime: json["entry_time"],
        exitTime: json["exit_time"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "day_date": dayDate,
        "entry_time": entryTime,
        "exit_time": exitTime,
        "status": status,
      };
}
