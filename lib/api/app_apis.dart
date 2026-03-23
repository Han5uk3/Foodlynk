import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:saver_bbk_main/models/generated_smart_shopping_list.dart';
import 'package:saver_bbk_main/models/protein_plan_model.dart';
import 'package:saver_bbk_main/models/smart_recipe_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';

class AppApis {
  static final String apiUrl =
      "https://us-central1-saver-app-2ae53.cloudfunctions.net/api";
  Future<GenaratedProteinPlanModel> generateProteinPlan(
    String whatareyoucooking,
    String towhomareyoucooking,
    int numberOfServings,
    List<String> dietaryPreferences,
    List<String> ingredients,
    String weight,
    bool isDieting,
  ) async {
    final url = Uri.parse("$apiUrl/api-features/generate-protein-plan");
    try {
      print('🚀 [API] Sending generateProteinPlan request to \$url');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['GEMINI_API_KEY'] ?? "",
        },
        body: jsonEncode({
          "whatAreYouCooking": whatareyoucooking,
          "toWhomAreYouCooking": towhomareyoucooking,
          "numberOfServings": numberOfServings,
          "dietaryPreferences": dietaryPreferences,
          "ingredients": ingredients,
          "weight": weight,
          "isDieting": isDieting,
        }),
      );
      
      print('📥 [API] generateProteinPlan response. Status: \${response.statusCode}');
      print('📥 [API] generateProteinPlan Body: \${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GenaratedProteinPlanModel.fromJson(json);
      } else {
        throw Exception(
          'Failed to generate protein plan: \${response.statusCode} - \${response.body}',
        );
      }
    } catch (e) {
      print('🚨 [API ERROR] generateProteinPlan: \$e');
      rethrow;
    }
  }

  Future<GenerateSmartRecipe> generateSmartRecipe(
    List<String> ingredients,
  ) async {
    final url = Uri.parse("$apiUrl/api-features/generate-smart-recipe");
    try {
      print('🚀 [API] Sending generateSmartRecipe request to $url');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['GEMINI_API_KEY'] ?? "",
          'x-unsplash-key': dotenv.env['UNSPLASH_ACCESS_KEY'] ?? "",
        },
        body: jsonEncode({"ingredients": ingredients}),
      );
      
      print('📥 [API] Received response. Status: ${response.statusCode}');
      print('📥 [API] Body length: ${response.body.length}, Body: ${response.body}');
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print('✅ [API] JSON decoded successfully.');
        return GenerateSmartRecipe.fromJson(json);
      } else {
        print('❌ [API] Non-200 Status Detected. Throwing Exception!');
        throw Exception(
          'Failed to generate smart recipe: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('🚨 [API ERROR] Error in generateSmartRecipe: $e');
      print('🚨 [STACK TRACE] $stackTrace');
      rethrow;
    }
  }

  Future<bool> sendNotificationToFCM({
    String? token,
    String? title,
    String? subTitle,
    String? type,
    String? chatRoomId,
    String? reciversUid,
  }) async {
    final url = Uri.parse("$apiUrl/api-features/sendNotification");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': token,
        'title': title,
        'body': subTitle,
        'type': type,
        'chatRoomId': chatRoomId,
      }),
    );
    if (response.statusCode == 200) {
      await Services.addNotification(
        RemoteMessage(
          data: {'type': type},
          notification: RemoteNotification(title: title, body: subTitle),
        ),
        reciversUid ?? "",
      );
      return true;
    } else {
      return false;
    }
  }

  Future<bool> comapreOnePlate(String beforeImage) async {
    final url = Uri.parse(
        "https://food-detection-api-292560943319.us-central1.run.app/classify");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image_url': beforeImage}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } else {
      throw Exception('Failed to compare one plate: ${response.statusCode}');
    }
  }

  Future<bool> compareTwoPlates(String beforeImage, String afterImage) async {
    final url = Uri.parse(
        "https://food-detection-api-292560943319.us-central1.run.app/compare");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'image_url1': beforeImage,
        'image_url2': afterImage,
      }),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'] ?? false;
    } else {
      throw Exception('Failed to compare two plates: ${response.statusCode}');
    }
  }

  Future<GnerateSmartShoppingList> generateSmartShoppingList(
      String recipeName, int numberOfServings) async {
    final url = Uri.parse("$apiUrl/api-features/generate-smart-shopping-list");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['GEMINI_API_KEY'] ?? "",
        },
        body: jsonEncode(
            {"recipeName": recipeName, "noServings": numberOfServings}),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // Backend returns { success: true, data: { ingredients: [...] } }
        // We only want the content inside "data"
        if (json["data"] != null) {
          return GnerateSmartShoppingList.fromJson(json["data"]);
        } else {
          return GnerateSmartShoppingList.fromJson(json);
        }
      } else {
        throw Exception(
          'Failed to generate smart shopping list: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> normalizeShoppingListItems(List<String> items) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";
    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=\$apiKey");
    
    final prompt = """
Take this list of missing ingredients and normalize them for a shopping app database.
Rules:
1. 'quantity' MUST be a purely numerical integer.
2. 'unit' MUST be strictly 'Nos'.
3. 'category' MUST be strictly one of exactly: ["Dairy", "Meat", "Oils", "Poultry", "Fruits", "Vegetables", "Seafood"]. If it doesn't fit perfectly, default to "Vegetables".
4. 'name' should be exactly the localized human readable item name including its intended pack/size wrapper.

Example: "1/4 cup of shredded cheese" -> {"name": "pack shredded cheese", "quantity": 1, "category": "Dairy"}

Input Ingredients: \${items.join(", ")}

Return ONLY a perfectly formatted JSON array with the exact keys: 'name' (String), 'quantity' (Integer), and 'category' (String). Do not return extra text.
""";

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [{"text": prompt}]
            }
          ],
          "generationConfig": {
            "responseMimeType": "application/json"
          }
        }),
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final rawText = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        final List<dynamic> parsedList = jsonDecode(rawText);
        return parsedList.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception("Failed to normalize items: \${response.statusCode} - \${response.body}");
      }
    } catch (e) {
      throw Exception("Error formatting with Gemini: \$e");
    }
  }
}
