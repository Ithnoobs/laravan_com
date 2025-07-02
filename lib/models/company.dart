import 'package:laravan_com/models/address.dart';

class Company {
  Address address;
  String department;
  String name;
  String title;

  Company({
    required this.address,
    required this.department,
    required this.name,
    required this.title,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        address: Address.fromJson(json["address"]),
        department: json["department"],
        name: json["name"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "department": department,
        "name": name,
        "title": title,
      };
}