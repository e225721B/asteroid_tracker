// database_Helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  // シングルトンパターンのためのコンストラクタ
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // データベースへのアクセサ
  Future<Database> get database async {
    if (_database != null) return _database!;
    // データベースが存在しない場合は初期化
    _database = await _initDatabase();
    return _database!;
  }

  // データベースの初期化
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'asteroids.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < newVersion) {
      // テーブルを削除して再作成
      await db.execute('DROP TABLE IF EXISTS favorites');
      await _onCreate(db, newVersion);
        }
      }
    );
  }

// テーブルの作成
Future _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE favorites(
      id TEXT PRIMARY KEY,
      name TEXT,
      close_approach_date TEXT,
      size REAL,
      miss_distance REAL,
      relative_velocity REAL
    )
  ''');
}

// お気に入りに追加
Future<void> addFavorite(Map<String, dynamic> asteroidData) async {
  final db = await database;

  // 必要な情報だけを取得
  Map<String, dynamic> favoriteData = {
    'id': asteroidData['id'].toString(),
    'name': asteroidData['name'] ?? 'Unknown',
    'close_approach_date': asteroidData['close_approach_data'] != null &&
            asteroidData['close_approach_data'].isNotEmpty &&
            asteroidData['close_approach_data'][0] != null &&
            asteroidData['close_approach_data'][0]['close_approach_date'] != null
        ? asteroidData['close_approach_data'][0]['close_approach_date']
        : null,
    'size': asteroidData['estimated_diameter'] != null &&
            asteroidData['estimated_diameter']['meters'] != null &&
            asteroidData['estimated_diameter']['meters']['estimated_diameter_max'] != null
        ? double.parse(asteroidData['estimated_diameter']['meters']['estimated_diameter_max'].toString()).floor()
        : null,
    'miss_distance': asteroidData['close_approach_data'] != null &&
            asteroidData['close_approach_data'].isNotEmpty &&
            asteroidData['close_approach_data'][0] != null &&
            asteroidData['close_approach_data'][0]['miss_distance'] != null &&
            asteroidData['close_approach_data'][0]['miss_distance']['kilometers'] != null
        ? double.parse(asteroidData['close_approach_data'][0]['miss_distance']['kilometers'].toString()).floor()
        : null,
    'relative_velocity': asteroidData['close_approach_data'] != null &&
            asteroidData['close_approach_data'].isNotEmpty &&
            asteroidData['close_approach_data'][0] != null &&
            asteroidData['close_approach_data'][0]['relative_velocity'] != null &&
            asteroidData['close_approach_data'][0]['relative_velocity']['kilometers_per_hour'] != null
        ? double.parse(asteroidData['close_approach_data'][0]['relative_velocity']['kilometers_per_hour'].toString()).floor()
        : null,
  };


  try {
    print("実行予定のINSERTクエリ: $favoriteData");

    await db.insert(
      'favorites',
      favoriteData,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("SQLクエリが正常に実行されました");
  } catch (e) {
    print("SQLクエリの実行時にエラーが発生しました: $e");
  }
}

  // お気に入りかどうかを確認
  Future<bool> isFavorite(String asteroidId) async {
    final db = await database;

    List<Map> result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [asteroidId],
    );

    return result.isNotEmpty;
  }

    // お気に入りから削除
  Future<void> removeFavorite(String asteroidId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [asteroidId],
    );
  }

  // お気に入りの小惑星IDをすべて取得
  Future<List<String>> getAllFavoriteAsteroidIds() async {
    final db = await database;
    List<Map> result = await db.query('favorites', columns: ['id']);
    return result.map((item) => item['id'].toString()).toList();
  }

  // お気に入りデータをすべて取得する
  Future<List<Map<String, dynamic>>> getAllFavoriteAsteroids() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query('favorites');
  // 必要に応じてJSON文字列をマップに戻す
    return result.map((item){
      item['links'] = jsonDecode(item['links']);
      return item;
    }).toList();
  }
}
