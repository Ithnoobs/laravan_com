import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:laravan_com/service/api_service.dart';
import 'package:http/http.dart' as http;

class ApiServiceImpli extends ApiService{
  @override
  Future<dynamic> getUrl(String url) async {
    var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 120));

    if(kDebugMode) {
      print("Request URL: $url");
      print("Response status: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Resource not found");
    } else if (response.statusCode == 500) {
      throw Exception("Server error");
    } else {
      throw Exception("Failed to load data");
    }
    
  }
}