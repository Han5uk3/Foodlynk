import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:saver_bbk_main/models/protein_plan_model.dart';
import 'package:saver_bbk_main/models/smart_recipe_model.dart';
import 'package:saver_bbk_main/services/app_services.dart';

class AppApis {
  static final String apiUrl = "https://saver-app-2ae53.uc.r.appspot.com";
  Future<GenaratedProteinPlanModel> generateProteinPlan(
    String whatareyoucooking,
    String towhomareyoucooking,
    int numberOfServings,
    List<String> dietaryPreferences,
    List<String> ingredients,
  ) async {
    final url = Uri.parse("$apiUrl/api-features/generate-protein-plan");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? "",
        },
        body: jsonEncode({
          "whatAreYouCooking": whatareyoucooking,
          "toWhomAreYouCooking": towhomareyoucooking,
          "numberOfServings": numberOfServings,
          "dietaryPreferences": dietaryPreferences,
          "ingredients": ingredients,
        }),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GenaratedProteinPlanModel.fromJson(json);
      } else {
        throw Exception(
          'Failed to generate protein plan: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GenerateSmartRecipe> generateSmartRecipe(
    List<String> ingredients,
  ) async {
    final url = Uri.parse("$apiUrl/api-features/generate-smart-recipe");
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? "",
        },
        body: jsonEncode({"ingredients": ingredients}),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GenerateSmartRecipe.fromJson(json);
      } else {
        throw Exception(
          'Failed to generate smart recipe: ${response.statusCode}',
        );
      }
    } catch (e) {
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
    final url = Uri.parse("$apiUrl/api-features/compareOnePlate");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imageUrl': beforeImage}),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'];
    } else {
      throw Exception('Failed to compare one plate: ${response.statusCode}');
    }
  }

  Future<bool> compareTwoPlates(String beforeImage, String afterImage) async {
    final url = Uri.parse("$apiUrl/api-features/comparePlate");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstImageUrl': beforeImage,
        'secondImageUrl': afterImage,
      }),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['status'];
    } else {
      throw Exception('Failed to compare two plates: ${response.statusCode}');
    }
  }
}
