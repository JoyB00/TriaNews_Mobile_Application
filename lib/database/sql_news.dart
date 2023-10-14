import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:news_pbp/entity/news.dart';

class SQLNews {
  //create
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE news(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        image TEXT,
        judul TEXT,
        deskripsi TEXT,
        author TEXT,
        kategori TEXT,
        date TEXT
      )
    """);
  }

  //read
  static Future<sql.Database> db() async {
    return sql.openDatabase('news.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addNews(String image, String judul, String deskripsi,
      String author, String kategori, String date) async {
    final db = await SQLNews.db();
    final data = {
      'image': image,
      'judul': judul,
      'deskripsi': deskripsi,
      'author': author,
      'kategori': kategori,
      'date': date
    };
    return await db.insert('news', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getNews() async {
    final db = await SQLNews.db();
    return db.query('news');
  }

  //update
  static Future<int> editNews(int id, String image, String judul,
      String deskripsi, String author, String kategori, String date) async {
    final db = await SQLNews.db();
    final data = {
      'image': image,
      'judul': judul,
      'deskripsi': deskripsi,
      'author': author,
      'kategori': kategori,
      'date': date
    };
    return await db.update('news', data, where: 'id = $id');
  }

  //delete
  static Future<int> deleteNews(int id) async {
    final db = await SQLNews.db();
    return await db.delete('news', where: 'id = $id');
  }
}

class SQLPhoto {}
