import 'package:news_pbp/entity/user.dart';

import 'dart:convert';
import 'package:http/http.dart';

class UserClient {
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/user';
  // static final String endpointLogin = '/api/login';
  // static final String endpointForgotPass = '/api/forgotpass';

  static final String url = '192.168.18.39';
  static final String endpoint = 'API_News/public/api/user';
  static final String endpointLogin = 'API_News/public/api/login';
  static final String endpointForgotPass = 'API_News/public/api/forgotpass';

  // mengambil data user dari API sesuai id
  static Future<User> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // membuat data user baru
  static Future<Response> create(User user) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      print(response.body);
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // login user
  static Future<User> login(User user) async {
    try {
      var response = await post(Uri.http(url, endpointLogin),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengubah data user sesuai ID
  static Future<Response> update(User user) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${user.id}'),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());
      // print(response.body);
      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // forgot password by email
  static Future<User> forgotPassword(User user) async {
    try {
      var response = await post(Uri.http(url, endpointForgotPass),
          headers: {"Content-Type": "application/json"},
          body: user.toRawJson());

      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }
      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
