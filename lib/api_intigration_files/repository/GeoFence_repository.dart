import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/GeoFencing_model.dart';

class GeoFenceRepository {
  final String baseUrl = "http://62.171.184.216:9595/api/employee/location/AddGeoPunch";

  Future<void> postData(GeoFenceModel feoFenceModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String corporateId = prefs.getString('corporate_id') ?? "";

    final apiUrl = "$baseUrl?CorporateId=$corporateId";

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final requestBody = jsonEncode(feoFenceModel.toJson());

    final response = await client.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      // Request was successful
      print("------------Response submitted Successfully Thanks!--------------");
      print(response.body);
    } else {
      // Request failed, log status code and response content
      print("Failed to fetch data from the API. Status code: ${response.statusCode}");
      print("Response content: ${response.body}");
      throw Exception("Failed to fetch data from the API.");
    }
  }
}
