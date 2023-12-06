import 'package:news_pbp/entity/news.dart';

import 'dart:convert';
import 'package:http/http.dart';

class NewsClient {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/news';
  // static final String url = '192.168.245.21';
  // static final String endpoint = 'API_News/public/api/news';

  // mengambil semua data news dari API
  static Future<List<News>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek News berdasarkan tiap element dari list
      return list.map((e) => News.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengambil data news dari API sesuai id
  static Future<News> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return News.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // membuat data news baru
  static Future<Response> create(News news) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: news.toRawJson());
      print(response.body);

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengubah data news sesuai ID
  static Future<Response> update(News news) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${news.id}'),
          headers: {"Content-Type": "application/json"},
          body: news.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Menghapus data news sesuai ID
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
