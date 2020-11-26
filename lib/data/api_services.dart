import 'package:dio/dio.dart';

class ApiServices {
  Dio launch() {
    Dio dio = new Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers["accept"] = 'application/json';
    dio.options.followRedirects = false;
    dio.options.validateStatus = (s) {
      return s < 500;
    };

    return dio;
  }
}
