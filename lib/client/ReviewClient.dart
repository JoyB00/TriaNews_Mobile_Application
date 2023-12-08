import 'package:news_pbp/entity/review.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ReviewClient {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/review';
  // static final String url = '192.168.245.21';
  // static final String endpoint = 'API_News/public/api/review';

  // membuat data review baru
  static Future<Response> create(Review review) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: review.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengambil semua data review dari API (ga kepake si)
  static Future<List<Review>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek Review berdasarkan tiap element dari list
      return list.map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengambil data review dari API sesuai id
  static Future<List<Review>> findbyNews(id) async {
    try {

      var response = await get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek Review berdasarkan tiap element dari list
      return list.map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengubah data review sesuai ID
  static Future<Response> update(Review review) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${review.id}'),
          headers: {"Content-Type": "application/json"},
          body: review.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Menghapus data review sesuai ID
  static Future<Response> delete(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}