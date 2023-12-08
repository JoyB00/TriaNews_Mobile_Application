import 'package:news_pbp/entity/testimoni.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_pbp/entity/user.dart';

class TestimoniClient {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/testimoni';
  // static final String url = '192.168.18.39';
  // static final String endpoint = 'API_News/public/api/testimoni';

  static Future<List<Testimoni>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];
      print(response.body);

      // list.map untuk membuat list objek Testimoni berdasarkan tiap element dari list
      return list.map((e) => Testimoni.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<User> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return User.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> create(Testimoni testimoni) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: testimoni.toRawJson());
      print(response.body);

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Testimoni testimoni) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${testimoni.id}'),
          headers: {"Content-Type": "application/json"},
          body: testimoni.toRawJson());
      print(response.body);
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
