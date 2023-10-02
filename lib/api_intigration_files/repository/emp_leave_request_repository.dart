import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/api_intigration_files/models/emp_leave_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmpLeaveRepository {
  Future<String> getCorporateId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? corporateId = prefs.getString('corporate_id');
    if (corporateId != null) {
      return corporateId;
    } else {
      throw Exception("Corporate ID not found in SharedPreferences");
    }
  }

  Future<List<EmpLeaveModel>> getData() async {
    final corporateId = await getCorporateId();
    final apiUrl =
        "http://62.171.184.216:9595/api/Leave/GetLeaveType?CorporateId=$corporateId";

    final headers = {
      'Content-Type': 'application/json', // Set the content type to JSON
    };

    final client = http.Client();

    final response = await client.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<EmpLeaveModel> leaveTypes =
          responseData.map((json) => EmpLeaveModel.fromJson(json)).toList();
      return leaveTypes;
    } else {
      throw Exception(
          "Failed to fetch data from the API. Status code: ${response.statusCode}");
    }
  }
}
