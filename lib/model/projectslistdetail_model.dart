// To parse this JSON data, do
//
//     final projectListDetail = projectListDetailFromJson(jsonString);

import 'dart:convert';

ProjectListDetail projectListDetailFromJson(String str) =>
    ProjectListDetail.fromJson(json.decode(str));

String projectListDetailToJson(ProjectListDetail data) =>
    json.encode(data.toJson());

class ProjectListDetail {
  String projectName;
  String id;
  String startDate;
  String deadline;
  int value;
  int bonus;
  String description;
  List<Assignee> assignee;

  ProjectListDetail({
    required this.projectName,
    required this.id,
    required this.startDate,
    required this.deadline,
    required this.value,
    required this.bonus,
    required this.description,
    required this.assignee,
  });

  factory ProjectListDetail.fromJson(Map<String, dynamic> json) =>
      ProjectListDetail(
        projectName: json["project_name"],
        id: json["id"],
        startDate: json["start_date"],
        deadline: json["deadline"],
        value: json["value"],
        bonus: json["bonus"],
        description: json["description"],
        assignee: List<Assignee>.from(
            json["assignee"].map((x) => Assignee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "id": id,
        "start_date": startDate,
        "deadline": deadline,
        "value": value,
        "bonus": bonus,
        "description": description,
        "assignee": List<dynamic>.from(assignee.map((x) => x.toJson())),
      };
}

class Assignee {
  String name;
  String position;
  String profilePhoto;

  Assignee({
    required this.name,
    required this.position,
    required this.profilePhoto,
  });

  factory Assignee.fromJson(Map<String, dynamic> json) => Assignee(
        name: json["name"],
        position: json["position"],
        profilePhoto: json["profile_photo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "position": position,
        "profile_photo": profilePhoto,
      };
}
