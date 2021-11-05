import 'dart:convert';

import 'package:http/http.dart';

class NetworkSerivce {
  final baseUrl = "https://jsonplaceholder.typicode.com/todos";
  Future<List<dynamic>> fetchTodos() async {
    try {
      final response = await get(Uri.parse("$baseUrl?userId=10"));
      return jsonDecode(response.body) as List;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> patchTodo(Map<String, String> patchObject, int id) async {
    try {
      await patch(Uri.parse("$baseUrl/$id"), body: patchObject);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> addTodo(Map<String, Object> todoObject) async {
    try {
      final response = await post(Uri.parse(baseUrl), body: todoObject);
      print('testttt');
      print(response);
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<bool> deleteTodo(int? id) async {
    try {
      await delete(Uri.parse("$baseUrl/$id"));
      return true;
    } catch (ex) {
      return false;
    }
  }
}
