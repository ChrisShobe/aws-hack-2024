import 'Ingredient.dart';
import 'Equipment.dart';
import 'Length.dart';

class Step {
  int number;
  String step;
  List<Ingredient> ingredients;
  List<Equipment> equipment;
  Length? length;

  Step({
    required this.number,
    required this.step,
    required this.ingredients,
    required this.equipment,
    this.length,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    var ingredientsList = (json['ingredients'] as List)
        .map((ingredient) => Ingredient.fromJson(ingredient))
        .toList();

    var equipmentList = (json['equipment'] as List)
        .map((equipment) => Equipment.fromJson(equipment))
        .toList();

    return Step(
      number: json['number'],
      step: json['step'],
      ingredients: ingredientsList,
      equipment: equipmentList,
      length: json['length'] != null
          ? Length.fromJson(json['length'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    var ingredientsList = ingredients.map((e) => e.toJson()).toList();
    var equipmentList = equipment.map((e) => e.toJson()).toList();

    return {
      'number': number,
      'step': step,
      'ingredients': ingredientsList,
      'equipment': equipmentList,
      'length': length?.toJson(),
    };
  }
}