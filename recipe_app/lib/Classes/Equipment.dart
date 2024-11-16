

class Equipment {
  int id;
  String name;
  String localizedName;
  String image;

  Equipment({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.image,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      localizedName: json['localizedName'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'localizedName': localizedName,
      'image': image,
    };
  }
}