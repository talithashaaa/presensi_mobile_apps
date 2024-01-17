// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  String uid;
  String email;
  String name;
  String position;

  Profile({
    required this.uid,
    required this.email,
    required this.name,
    required this.position,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        uid: json["UID"],
        email: json["email"],
        name: json["name"],
        position: json["position"],
      );

  Map<String, dynamic> toJson() => {
        "UID": uid,
        "email": email,
        "name": name,
        "position": position,
      };
}
