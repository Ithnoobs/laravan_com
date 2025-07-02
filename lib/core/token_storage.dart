import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:laravan_com/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static String? accessToken;
  static String? refreshToken;
  static User? currentUser;

  static Future load() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');

    final userStr = prefs.getString('user');
    if (userStr != null) {
      currentUser = User.fromJson(jsonDecode(userStr));
    }

    if (kDebugMode) {
    print('TokenStorage loaded:');
    print('- accessToken: $accessToken');
    print('- refreshToken: $refreshToken');
    print('- currentUser: $currentUser');
  }
  }

  static Future saveTokens(String access, String refresh) async {
    accessToken = access;
    refreshToken = refresh;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', access);
    await prefs.setString('refresh_token', refresh);

    if (kDebugMode) {
      print('Saved user: ${currentUser?.username}, image: ${currentUser?.image}');
    }
  }

  static Future saveUser(Map<String, dynamic> userJson) async {
    currentUser = User.fromJson(userJson);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(userJson));
  }

  static Future clear() async {
    accessToken = null;
    refreshToken = null;
    currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user');
  }
}
