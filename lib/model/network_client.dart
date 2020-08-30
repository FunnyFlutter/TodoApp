import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:todo_list/model/todo.dart';

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

  Future<String> uploadList(List<Todo> list, String userKey) async {
    Map result = {};
    try {
      Response response = await post(
        '$baseUrl/list',
        body: JsonEncoder().convert({
          'userKey': userKey,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': list.map((todo) => todo.toMap()).toList(),
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      result = JsonDecoder().convert(response.body);
    } catch (e) {
      result['error'] = '服务器请求失败，请检查网络连接';
    }
    return result['error'];
  }

  Future<FetchListResult> fetchList(String userKey) async {
    FetchListResult result;
    try {
      Response response = await get(
        '$baseUrl/list?userKey=$userKey',
        headers: commonHeaders,
      );
      result = FetchListResult.fromJson(JsonDecoder().convert(response.body));
    } catch (e) {
      result = FetchListResult(error: '服务器请求失败，请检查网络连接');
    }
    return result;
    ;
  }
}

class FetchListResult {
  final List<Todo> data;
  final DateTime timestamp;
  final String error;

  FetchListResult({this.data, this.timestamp, this.error = ''});

  factory FetchListResult.fromJson(Map<dynamic, dynamic> json) {
    return FetchListResult(
      data: json['data']['data'].map<Todo>((e) => Todo.fromMap(e)).toList(),
      timestamp: DateTime.fromMicrosecondsSinceEpoch(json['data']['timestamp']),
    );
  }
}
