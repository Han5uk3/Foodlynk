import 'dart:convert';

class GenaratedProteinPlanModel {
  final bool? success;
  final Data? data;

  GenaratedProteinPlanModel({this.success, this.data});

  GenaratedProteinPlanModel copyWith({bool? success, Data? data}) =>
      GenaratedProteinPlanModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory GenaratedProteinPlanModel.fromRawJson(String str) =>
      GenaratedProteinPlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenaratedProteinPlanModel.fromJson(Map<String, dynamic> json) =>
      GenaratedProteinPlanModel(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};
}

class Data {
  final String? recipeName;
  final List<Ingredient>? ingredients;
  final NutritionalInfo? nutritionalInfo;

  Data({this.recipeName, this.ingredients, this.nutritionalInfo});

  Data copyWith({
    String? recipeName,
    List<Ingredient>? ingredients,
    NutritionalInfo? nutritionalInfo,
  }) => Data(
    recipeName: recipeName ?? this.recipeName,
    ingredients: ingredients ?? this.ingredients,
    nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
  );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    recipeName: json["recipeName"],
    ingredients:
        json["ingredients"] == null
            ? []
            : List<Ingredient>.from(
              json["ingredients"]!.map((x) => Ingredient.fromJson(x)),
            ),
    nutritionalInfo:
        json["nutritionalInfo"] == null
            ? null
            : NutritionalInfo.fromJson(json["nutritionalInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "recipeName": recipeName,
    "ingredients":
        ingredients == null
            ? []
            : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
    "nutritionalInfo": nutritionalInfo?.toJson(),
  };
}

class Ingredient {
  final String? name;
  final String? quantity;

  Ingredient({this.name, this.quantity});

  Ingredient copyWith({String? name, String? quantity}) =>
      Ingredient(name: name ?? this.name, quantity: quantity ?? this.quantity);

  factory Ingredient.fromRawJson(String str) =>
      Ingredient.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      Ingredient(name: json["name"], quantity: json["quantity"]);

  Map<String, dynamic> toJson() => {"name": name, "quantity": quantity};
}

class NutritionalInfo {
  final String? calories;
  final String? protein;
  final String? carbs;

  NutritionalInfo({this.calories, this.protein, this.carbs});

  NutritionalInfo copyWith({
    String? calories,
    String? protein,
    String? carbs,
  }) => NutritionalInfo(
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
  );

  factory NutritionalInfo.fromRawJson(String str) =>
      NutritionalInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) =>
      NutritionalInfo(
        calories: json["calories"],
        protein: json["protein"],
        carbs: json["carbs"],
      );

  Map<String, dynamic> toJson() => {
    "calories": calories,
    "protein": protein,
    "carbs": carbs,
  };
}
