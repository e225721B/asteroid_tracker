// favorite_indicator.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'favorite_provider.dart'; // プロバイダをインポート

class FavoriteIndicator extends ConsumerWidget {
  final Map<String, dynamic> asteroidData; // 小惑星のデータを受け取る

  FavoriteIndicator({required this.asteroidData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // お気に入りのリストを取得
    final favoriteAsteroids = ref.watch(favoriteProvider);
    final asteroidId = asteroidData['id'].toString();

    // 現在の小惑星がお気に入りかどうかを確認
    final isFavorite = favoriteAsteroids.contains(asteroidId);

    return Row(
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Colors.yellow : Colors.grey,
          ),
          onPressed: () => toggleFavorite(ref, isFavorite), // refとisFavoriteを渡す
        ),
        Text(
          isFavorite ? 'お気に入りに登録済み' : 'お気に入りに登録',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // お気に入りを追加または削除する
  void toggleFavorite(WidgetRef ref, bool isFavorite) async {
    final favoriteNotifier = ref.read(favoriteProvider.notifier);
    final asteroidId = asteroidData['id'].toString();

    if (isFavorite) {
      // お気に入りから削除
      await favoriteNotifier.removeFavorite(asteroidId);
    } else {
      // お気に入りに追加
      await favoriteNotifier.addFavorite(asteroidData);
    }
  }
}