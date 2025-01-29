// favorite_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asteroid/database/database_Helper.dart';

class FavoriteNotifier extends StateNotifier<List<String>> {
  final DatabaseHelper dbHelper;

  FavoriteNotifier(this.dbHelper) : super([]) {
    // 初期化時にデータベースからお気に入りをロード
    loadFavorites();
  }

  // お気に入りをロードする非同期関数
  Future<void> loadFavorites() async {
    List<String> favorites = await dbHelper.getAllFavoriteAsteroidIds();
    state = favorites;

      // デバッグログに全てのデータを表示
    List<Map<String, dynamic>> allFavorites = await dbHelper.getAllFavoriteAsteroids();
    print('保存されているお気に入りデータ: $allFavorites');
  }

  // お気に入りに追加（修正後）
  Future<void> addFavorite(Map<String, dynamic> asteroidData) async {
    await dbHelper.addFavorite(asteroidData);
    state = [...state, asteroidData['id'].toString()];
  }

  // お気に入りから削除
  Future<void> removeFavorite(String asteroidId) async {
    await dbHelper.removeFavorite(asteroidId);
    state = state.where((id) => id != asteroidId).toList();
  }

  // お気に入りかどうかを確認
  bool isFavorite(String asteroidId) {
    return state.contains(asteroidId);
  }

}

// プロバイダの定義
final favoriteProvider = StateNotifierProvider<FavoriteNotifier, List<String>>((ref) {
  final dbHelper = DatabaseHelper.instance; // シングルトンインスタンスを使用
  return FavoriteNotifier(dbHelper);
});

