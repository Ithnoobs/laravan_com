import 'package:flutter/foundation.dart';
import 'package:laravan_com/constants/api.dart';
import 'package:laravan_com/core/token_storage.dart';

class AuthService {
  static Future<bool> login(String user, String pass) async {
    try {
      final r = await Api.dio.post(
        '/auth/login',
        data: {
          'username': user,
          'password': pass,
          'expiresInMins': 60,
        });

      if(kDebugMode) {
        print('Login request: ${r.requestOptions.data}');
        print('Login response: ${r.data}');
        print('Keys in response: ${r.data.keys}');
      }

      await TokenStorage.saveTokens(
        r.data['accessToken'],
        r.data['refreshToken'],
      );

      final userJson = Map<String, dynamic>.from(r.data);
      userJson.remove('accessToken');
      userJson.remove('refreshToken');

      await TokenStorage.saveUser(userJson);
      return true;
    } catch (e) {
      if (kDebugMode) {
      print('Login error: $e');
      }
      return false;
    }
  }

  static Future<bool> register(String user, String pass) async {
    try {
      final r = await Api.dio.post(
        '/auth/register',
        data: {
          'username': user,
          'password': pass,
          'expiresInMins': 60,
        });
      
      if(kDebugMode) {
        print('Register request: ${r.requestOptions.data}');
        print('Register response: ${r.data}');
        print('Keys in response: ${r.data.keys}');
      }
      
      await TokenStorage.saveTokens(r.data['accessToken'], r.data['refreshToken']);
      
      final userJson = Map<String, dynamic>.from(r.data);
      userJson.remove('accessToken');
      userJson.remove('refreshToken');

      await TokenStorage.saveUser(userJson);
      return true;
    }catch (e) {
      if (kDebugMode) {
        print('Register error: $e');
      }
      return false;
    }
  }
}