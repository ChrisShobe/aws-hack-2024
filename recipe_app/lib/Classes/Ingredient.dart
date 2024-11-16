class Ingredient {
  int? id;
  String? aisle;
  String? image;
  String? name;
  String? nameClean;
  String? original;
  String? originalName;
  double? amount;
  String? unit;
  Map<String, dynamic>? meta;
  Map<String, dynamic>? measures;

  Ingredient({
    this.id,
    this.aisle,
    this.image,
    this.name,
    this.nameClean,
    this.original,
    this.originalName,
    this.amount,
    this.unit,
    this.meta,
    this.measures,
   
  }
  );
  

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    print("IngredientFromJson Called");
    return Ingredient(
      id: json['id'],
      aisle: json['aisle'],
      image: json['image'],
      name: json['name'],
      nameClean: json['nameClean'],
      original: json['original'],
      originalName: json['originalName'],
      amount: json['amount'] != null ? json['amount'].toDouble() : null,
      unit: json['unit'],
      meta: json['meta'] ?? {},
      measures: json['measures'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aisle': aisle,
      'image': image,
      'name': name,
      'nameClean': nameClean,
      'original': original,
      'originalName': originalName,
      'amount': amount,
      'unit': unit,
      'meta': meta,
      'measures': measures,
    };
  }
}
