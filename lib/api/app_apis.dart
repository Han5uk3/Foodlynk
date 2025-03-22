import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class AppApis {
  static final String apiUrl =
      'https://8598-2405-201-f00a-7082-5030-d53c-cb34-a655.ngrok-free.app';

  Future<bool> createNewItem(Map<String, dynamic> newItem, String uid) async {
    String url = '$apiUrl/addKitchenItem';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"uid": uid, "item": newItem}),
    );
    log(response.body);
    log({"uid": uid, "item": newItem}.toString());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'];
    } else {
      throw Exception('Failed to create item: ${response.statusCode}');
    }
  }

  Future<bool> removeItem(String uid, String itemId) async {
    log("PI CLLING");
    String url = '$apiUrl/deleteKitchenItem';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"uid": uid, "itemId": itemId}),
    );
    log(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['success'];
    } else {
      throw Exception('Failed to delete item: ${response.statusCode}');
    }
  }
}
