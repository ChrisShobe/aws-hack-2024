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
  });

  // To convert from JSON
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
      meta: json['meta'],  // No default empty map, allow null
      measures: json['measures'],  // No default empty map, allow null
    );
  }

  // To convert to JSON
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (aisle != null) data['aisle'] = aisle;
    if (image != null) data['image'] = image;
    if (name != null) data['name'] = name;
    if (nameClean != null) data['nameClean'] = nameClean;
    if (original != null) data['original'] = original;
    if (originalName != null) data['originalName'] = originalName;
    if (amount != null) data['amount'] = amount;
    if (unit != null) data['unit'] = unit;
    if (meta != null && meta!.isNotEmpty) data['meta'] = meta;
    if (measures != null && measures!.isNotEmpty) data['measures'] = measures;
    return data;
  }
}
