class Hair {
  String color;
  String type;

  Hair({required this.color, required this.type});

  factory Hair.fromJson(Map<String, dynamic> json) =>
      Hair(color: json["color"], type: json["type"]);

  Map<String, dynamic> toJson() => {
        "color": color,
        "type": type,
      };
}