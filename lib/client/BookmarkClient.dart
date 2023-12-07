import 'dart:convert';
import 'package:http/http.dart';
import 'package:news_pbp/entity/news.dart';
import 'package:news_pbp/entity/bookmark.dart';

class BookmarkClient {
  // static final String url = '10.0.2.2:8000';
  // static final String endpoint = '/api/bookmark';
  static final String url = '192.168.18.39';
  static final String endpoint = 'API_News/public/api/bookmark';

  // mengambil semua data Bookmark dari API
  static Future<List<Bookmark>> fetchAll() async {
    try {
      var response = await get(Uri.http(url, endpoint));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek Bookmark berdasarkan tiap element dari list
      return list.map((e) => Bookmark.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<List<News>> getBookmarkNews(id) async {
    try {
      // var response = await get(Uri.http(url, '/api/getBookmarkNews/$id'));
      var response =
          await get(Uri.http(url, 'API_News/public/api/getBookmarkNews/$id'));
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      // mengambil bagian data dari response body
      Iterable list = json.decode(response.body)['data'];

      // list.map untuk membuat list objek Bookmark berdasarkan tiap element dari list
      return list.map((e) => News.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // mengambil data Bookmark dari API sesuai id
  static Future<Bookmark> find(id) async {
    try {
      var response = await get(Uri.http(url, '$endpoint/$id')); //request ke api
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return Bookmark.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<Bookmark> findBookmark(id_berita, id_user) async {
    try {
      // var response = await get(Uri.http(
      //     url, '/api/findBookmark/$id_berita/$id_user')); //request ke api
      var response = await get(Uri.http(url,
          'API_News/public/api/findBookmark/$id_berita/$id_user')); //request ke api
      print('${response.body} ${response.statusCode}');
      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return Bookmark.fromJson(json.decode(response.body)['data']);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // membuat data Bookmark baru
  static Future<Response> create(Bookmark bookmark) async {
    try {
      var response = await post(Uri.http(url, endpoint),
          headers: {"Content-Type": "application/json"},
          body: bookmark.toRawJson());
      print(response.body);

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Mengubah data Bookmark sesuai ID
  static Future<Response> update(Bookmark bookmark) async {
    try {
      var response = await put(Uri.http(url, '$endpoint/${bookmark.id}'),
          headers: {"Content-Type": "application/json"},
          body: bookmark.toRawJson());

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // Menghapus data Bookmark sesuai ID
  static Future<Response> destroy(id) async {
    try {
      var response = await delete(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200) throw Exception(response.reasonPhrase);
      print(response.body);

      return response;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
