class Dimensions {
    double width;
    double height;
    double depth;

    Dimensions({
        required this.width,
        required this.height,
        required this.depth,
    });

    factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        width: json["width"]?.toDouble(),
        height: json["height"]?.toDouble(),
        depth: json["depth"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "depth": depth,
    };
}