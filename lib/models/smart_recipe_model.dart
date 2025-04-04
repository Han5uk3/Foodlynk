import 'dart:convert';

class GenerateSmartRecipe {
    final bool? success;
    final Data? data;

    GenerateSmartRecipe({
        this.success,
        this.data,
    });

    GenerateSmartRecipe copyWith({
        bool? success,
        Data? data,
    }) => 
        GenerateSmartRecipe(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory GenerateSmartRecipe.fromRawJson(String str) => GenerateSmartRecipe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory GenerateSmartRecipe.fromJson(Map<String, dynamic> json) => GenerateSmartRecipe(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
    };
}

class Data {
    final List<Recipe>? recipes;

    Data({
        this.recipes,
    });

    Data copyWith({
        List<Recipe>? recipes,
    }) => 
        Data(
            recipes: recipes ?? this.recipes,
        );

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        recipes: json["recipes"] == null ? [] : List<Recipe>.from(json["recipes"]!.map((x) => Recipe.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "recipes": recipes == null ? [] : List<dynamic>.from(recipes!.map((x) => x.toJson())),
    };
}

class Recipe {
    final String? foodName;
    final String? cookingTime;
    final List<Step>? steps;
    final String? imageUrl;

    Recipe({
        this.foodName,
        this.cookingTime,
        this.steps,
        this.imageUrl,
    });

    Recipe copyWith({
        String? foodName,
        String? cookingTime,
        List<Step>? steps,
        String? imageUrl,
    }) => 
        Recipe(
            foodName: foodName ?? this.foodName,
            cookingTime: cookingTime ?? this.cookingTime,
            steps: steps ?? this.steps,
            imageUrl: imageUrl ?? this.imageUrl,
        );

    factory Recipe.fromRawJson(String str) => Recipe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        foodName: json["food_name"],
        cookingTime: json["cooking_time"],
        steps: json["steps"] == null ? [] : List<Step>.from(json["steps"]!.map((x) => Step.fromJson(x))),
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "food_name": foodName,
        "cooking_time": cookingTime,
        "steps": steps == null ? [] : List<dynamic>.from(steps!.map((x) => x.toJson())),
        "image_url": imageUrl,
    };
}

class Step {
    final int? step;
    final String? whatToDo;

    Step({
        this.step,
        this.whatToDo,
    });

    Step copyWith({
        int? step,
        String? whatToDo,
    }) => 
        Step(
            step: step ?? this.step,
            whatToDo: whatToDo ?? this.whatToDo,
        );

    factory Step.fromRawJson(String str) => Step.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Step.fromJson(Map<String, dynamic> json) => Step(
        step: json["step"],
        whatToDo: json["whatToDo"],
    );

    Map<String, dynamic> toJson() => {
        "step": step,
        "whatToDo": whatToDo,
    };
}
