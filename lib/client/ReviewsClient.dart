import 'package:news_pbp/entity/reviews.dart';
import 'package:news_pbp/entity/testimoni.dart';

import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_pbp/entity/user.dart';

class ReviewClient {
  // static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/review';

  static final String url = '20.40.101.65:8000';
  // static final String endpoint = 'API_News/public/api/review';

  static Future<List<Review>> fetchAll(id) async {
    try {
      var response = await get(Uri.http(url, '/api/review/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];
      print(response.body);

      // list.map untuk membuat list objek Testimoni berdasarkan tiap element dari list
      return list.map((e) => Review.fromJson(e)).toList();
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

  static Future<Response> create(Review review) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: review.toRawJson());
      // print(response.body);

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Response> update(Review review) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${review.id}'),
          headers: {"Content-Type": "application/json"},
          body: review.toRawJson());
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
