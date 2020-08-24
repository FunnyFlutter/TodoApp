import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

const Map<String, String> commonHeaders = {'Content-Type': 'application/json'};
final String baseUrl =
    Platform.isAndroid ? 'http://10.0.2.2:8989' : 'http://localhost:8989';

class NetworkClient {
  NetworkClient._();

  static NetworkClient _client = NetworkClient._();

  factory NetworkClient.instance() => _client;

  Future<String> login(String email, String password) async {
    Map result;
    try {
      Response response = await post(
        '$baseUrl/login',
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: commonHeaders,
      );
      result = JsonDecoder().convert(response.body);
    } catch (e) {
      result['error'] = '登录失败\n错误信息为 $e';
    }
    return result['error'];
  }

  Future<String> register(
    String email,
    String password, {
    File image,
  }) async {
    Map result;
    try {
      String responseJson;
      String url = '$baseUrl/register';
      if (image != null && image.existsSync()) {
        MultipartRequest request = MultipartRequest('POST', Uri.parse(url));
        request.fields['email'] = email;
        request.fields['password'] = password;
        MultipartFile file =
            await MultipartFile.fromPath('image', image.absolute.path);
        request.files.add(file);
        StreamedResponse response = await request.send();
        responseJson = await response.stream.bytesToString();
      } else {
        Response response = await post(
          url,
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: commonHeaders,
        );
        responseJson = response.body;
      }

      result = JsonDecoder().convert(responseJson);
    } catch (e) {
      result['error'] = '注册失败\n错误信息为 $e';
    }
    return result['error'];
  }
}
