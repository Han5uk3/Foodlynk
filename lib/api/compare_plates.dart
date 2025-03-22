// ignore: depend_on_referenced_packages

import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<bool> comparePlates(File beforeImage, File afterImage) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      'https://6133-2409-40f3-100f-6a12-9c92-287c-2fad-1096.ngrok-free.app/compare',
    ),
  );

  request.files.add(
    await http.MultipartFile.fromPath('before', beforeImage.path),
  );
  request.files.add(
    await http.MultipartFile.fromPath('after', afterImage.path),
  );

  var response = await request.send();
  var responseData = await response.stream.bytesToString();

  log('Response Status Code: ${response.statusCode}');
  log('Response Data: $responseData');

  try {
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final data = json.decode(responseData);
        log("Plate Empty: ${data['plate_empty']}");
        return data['plate_empty'];
      } else {
        log("Unexpected response: $response");

        return false;
      }
    } else {
      log("Error: ${response.statusCode} - $response");
    }
  } catch (e) {
    log('Error decoding JSON: $e');
    return false;
  }
  return false;
}

Future<bool> detectFood(File image) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse(
      'https://6133-2409-40f3-100f-6a12-9c92-287c-2fad-1096.ngrok-free.app/plateIsEmpty',
    ),
  );

  request.files.add(await http.MultipartFile.fromPath('plate', image.path));

  var response = await request.send();
  var responseData = await response.stream.bytesToString();

  log('Response Status Code: ${response.statusCode}');
  log('Response Data: $responseData');

  try {
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final data = json.decode(responseData);
        log("has food: ${data['plate_empty']}");
        return data['plate_empty'];
      } else {
        log("Unexpected response: $response");

        return false;
      }
    } else {
      log("Error: ${response.statusCode} - $response");
    }
  } catch (e) {
    log('Error decoding JSON: $e');
    return false;
  }
  return false;
}
