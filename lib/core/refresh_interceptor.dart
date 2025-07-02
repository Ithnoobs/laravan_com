import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:laravan_com/constants/api.dart';
import 'package:laravan_com/core/token_storage.dart';

class RefreshInterceptor extends Interceptor {
  bool isRefreshing = false;
  final _queue = Queue<RequestOptions>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TokenStorage.accessToken;
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final resp = err.response;
    if (resp?.statusCode == 401 && !isRefreshing) {
      isRefreshing = true;
      _queue.add(err.requestOptions);

      try {
        final r = await Dio().post(
          Api.refresh,
          data: {
            'refreshToken': TokenStorage.refreshToken,
            'expiresInMins': 60,
          },
        );
        TokenStorage.saveTokens(
          r.data['accessToken'],
          r.data['refreshToken'],
        );
        for (var req in _queue) {
          Api.dio.fetch(req);
        }
      } catch (_) {
        await TokenStorage.clear();
      } finally {
        _queue.clear();
        isRefreshing = false;
      }
      handler.resolve(await Api.dio.fetch(err.requestOptions));
    } else {
      handler.next(err);
    }
  }
}