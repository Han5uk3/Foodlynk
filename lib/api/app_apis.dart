import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:saver_bbk_main/models/protein_plan_model.dart';

class AppApis {
  static final String apiUrl = 'https://api-ab2ifjorfa-uc.a.run.app';

  Future<bool> createNewItem(Map<String, dynamic> newItem, String uid) async {
    String url = '$apiUrl/addKitchenItem';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"uid": uid, "item": newItem}),
    );
    log(url);
    log(response.body);
    log({"uid": uid, "item": newItem}.toString());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'];
    } else {
      throw Exception('Failed to create item: ${response.statusCode}');
    }
  }

  Future<bool> removeItem(
    String uid,
    String itemId,
    bool isBeforeExpiry,
    int itemCount,
  ) async {
    log("PI CLLING");
    String url = '$apiUrl/deleteKitchenItem';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "uid": uid,
        "itemId": itemId,
        "isExpaired": isBeforeExpiry,
        "noOfQuantity": itemCount,
      }),
    );
    log(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'];
    } else {
      throw Exception('Failed to delete item: ${response.statusCode}');
    }
  }

  Future<GenaratedProteinPlanModel> generateProteinPlan(
    String whatareyoucooking,
    String towhomareyoucooking,
    int numberOfServings,
    List<String> dietaryPreferences,
    List<String> ingredients,
  ) async {
    final url = Uri.parse("$apiUrl/generate-protein-plan");
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
}
