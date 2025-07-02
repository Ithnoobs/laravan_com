import 'package:dio/dio.dart';
import '../core/refresh_interceptor.dart';

abstract class Api {
  static const String baseUri = "https://dummyjson.com/";
  static const String getAllProducts = "${baseUri}products";
  static const String searchProducts = "${baseUri}products/search";
  static const String login = "${baseUri}auth/login";
  static const String register = "${baseUri}auth/register";
  static const String refresh = "${baseUri}auth/refresh";
  static const String users = "${baseUri}users";

  static final Dio dio = Dio(BaseOptions(baseUrl: baseUri))
    ..interceptors.add(RefreshInterceptor());
}
