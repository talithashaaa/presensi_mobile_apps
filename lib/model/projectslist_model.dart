// To parse this JSON data, do
//
//     final projectsList = projectsListFromJson(jsonString);

import 'dart:convert';

List<ProjectsList> projectsListFromJson(String str) => List<ProjectsList>.from(
    json.decode(str).map((x) => ProjectsList.fromJson(x)));

String projectsListToJson(List<ProjectsList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectsList {
  String id;
  String projectName;
  String startDate;
  String deadline;
  int value;
  String description;
  List<Assignee> assignee;
  String status;
  int month;

  ProjectsList({
    required this.id,
    required this.projectName,
    required this.startDate,
    required this.deadline,
    required this.value,
    required this.description,
    required this.assignee,
    required this.status,
    required this.month,
  });

  factory ProjectsList.fromJson(Map<String, dynamic> json) => ProjectsList(
        id: json["id"],
        projectName: json["project_name"],
        startDate: json["start_date"],
        deadline: json["deadline"],
        value: json["value"],
        description: json["description"],
        assignee: List<Assignee>.from(
            json["assignee"].map((x) => Assignee.fromJson(x))),
        status: json["status"],
        month: json["month"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_name": projectName,
        "start_date": startDate,
        "deadline": deadline,
        "value": value,
        "description": description,
        "assignee": List<dynamic>.from(assignee.map((x) => x.toJson())),
        "status": status,
        "month": month,
      };
}

class Assignee {
  String name;
  String position;

  Assignee({
    required this.name,
    required this.position,
  });

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
        name: json["name"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
      };
}
