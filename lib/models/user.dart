import 'package:laravan_com/models/address.dart';
import 'package:laravan_com/models/bank.dart';
import 'package:laravan_com/models/company.dart';
import 'package:laravan_com/models/hair.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String? maidenName;
  int? age;
  String gender;
  String email;
  String? phone;
  String username;
  String? password;
  String? birthDate;
  String? image;
  String? bloodGroup;
  int? height;
  double? weight;
  String? eyeColor;
  Hair? hair;
  String? domain;
  String? ip;
  Address? address;
  String? macAddress;
  String? university;
  Bank? bank;
  Company? company;
  String? ein;
  String? ssn;
  String? userAgent;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.maidenName,
    this.age,
    required this.gender,
    required this.email,
    this.phone,
    required this.username,
    this.password,
    this.birthDate,
    this.image,
    this.bloodGroup,
    this.height,
    this.weight,
    this.eyeColor,
    this.hair,
    this.domain,
    this.ip,
    this.address,
    this.macAddress,
    this.university,
    this.bank,
    this.company,
    this.ein,
    this.ssn,
    this.userAgent,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        maidenName: json["maidenName"],
        age: json["age"],
        gender: json["gender"],
        email: json["email"],
        phone: json["phone"],
        username: json["username"],
        password: json["password"],
        birthDate: json["birthDate"],
        image: json["image"],
        bloodGroup: json["bloodGroup"],
        height: json["height"],
        weight: json["weight"]?.toDouble(),
        eyeColor: json["eyeColor"],
        hair: json["hair"] != null ? Hair.fromJson(json["hair"]) : null,
        domain: json["domain"],
        ip: json["ip"],
        address: json["address"] != null ? Address.fromJson(json["address"]) : null,
        macAddress: json["macAddress"],
        university: json["university"],
        bank: json["bank"] != null ? Bank.fromJson(json["bank"]) : null,
        company: json["company"] != null ? Company.fromJson(json["company"]) : null,
        ein: json["ein"],
        ssn: json["ssn"],
        userAgent: json["userAgent"],
      );
}
