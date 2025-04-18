import 'dart:convert';

class GnerateSmartShoppingList {
    final List<Ingredient>? ingredients;

    GnerateSmartShoppingList({
        this.ingredients,
    });

    GnerateSmartShoppingList copyWith({
        List<Ingredient>? ingredients,
    }) => 
        GnerateSmartShoppingList(
            ingredients: ingredients ?? this.ingredients,
        );

    factory GnerateSmartShoppingList.fromRawJson(String str) => GnerateSmartShoppingList.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GnerateSmartShoppingList.fromJson(Map<String, dynamic> json) => GnerateSmartShoppingList(
        ingredients: json["ingredients"] == null ? [] : List<Ingredient>.from(json["ingredients"]!.map((x) => Ingredient.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ingredients": ingredients == null ? [] : List<dynamic>.from(ingredients!.map((x) => x.toJson())),
    };
}

class Ingredient {
    final String? name;
    final String? quantity;

    Ingredient({
        this.name,
        this.quantity,
    });

    Ingredient copyWith({
        String? name,
        String? quantity,
    }) => 
        Ingredient(
            name: name ?? this.name,
            quantity: quantity ?? this.quantity,
        );

    factory Ingredient.fromRawJson(String str) => Ingredient.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        name: json["name"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "quantity": quantity,
    };
}
