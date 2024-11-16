
class Length {
  int number;
  String unit;

  Length({
    required this.number,
    required this.unit,
  });

  factory Length.fromJson(Map<String, dynamic> json) {
    return Length(
      number: json['number'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'unit': unit,
    };
  }
}