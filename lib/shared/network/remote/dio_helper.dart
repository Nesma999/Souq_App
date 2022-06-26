import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;
  late Response response;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
        connectTimeout:50000 ,
        receiveTimeout:30000 ,
         ),
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang ='en',
    String? token,
  }) async {
    //3shan azod 3la el headers
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };

    return await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang ='en',
    String? token,
  }) async {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio!.get(url,queryParameters:query);
  }

  static Future<Response> updateData({
    required String url,
    required Map<String, dynamic> data,
    String lang ='en',
    String? token,
})async{
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await dio!.put(url,data:data );
  }
}
