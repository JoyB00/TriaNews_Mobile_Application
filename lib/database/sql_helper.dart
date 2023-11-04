import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  //create
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        email TEXT UNIQUE,
        notelp TEXT,
        username TEXT,
        password TEXT,
        dateofbirth TEXT,
        image TEXT
      )
    """);
  }

  //read
  static Future<sql.Database> db() async {
    return sql.openDatabase('user.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> addUser(String email, String notelp, String username,
      String password, String dateofbirth) async {
    final db = await SQLHelper.db();
    final data = {
      'email': email,
      'notelp': notelp,
      'username': username,
      'password': password,
      'dateofbirth': dateofbirth
    };
    return await db.insert('user', data);
  }

  //read
  static Future<List<Map<String, dynamic>>> getUser(int userId) async {
    final db = await SQLHelper.db();
    return db.query('user', where: 'id = ?', whereArgs: [userId]);
  }

  //update
  static Future<int> editUser(int id, String email, String notelp,
      String username, String password) async {
    final db = await SQLHelper.db();
    final data = {
      'email': email,
      'notelp': notelp,
      'username': username,
      'password': password
    };
    return await db.update('user', data, where: 'id = $id');
  }

  //delete
  static Future<int> deleteUser(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('user', where: 'id = $id');
  }

  //login user
  static Future<List<Map<String, dynamic>>> loginUser(
      String username, String password) async {
    final db = await SQLHelper.db();
    return db.query('user',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
  }

  //add image for profile
  static Future<int> addImage(String image, int id) async {
    final db = await SQLHelper.db();
    final data = {'image': image};
    return await db.update('user', data, where: 'id = $id');
  }
}
