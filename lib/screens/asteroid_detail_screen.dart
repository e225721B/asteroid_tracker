import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asteroid/services/favorite_indicator.dart';

class AsteroidDetailScreen extends ConsumerWidget {
  final Map<String, dynamic> asteroid;

  // コンストラクタで小惑星のデータを受け取る
  AsteroidDetailScreen({required this.asteroid});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(asteroid["name"]),
      ),
      body:Center(
        child: Column(
          children: [
          Text('接近日時: ${asteroid['close_approach_data'][0]['close_approach_date']}'),
          Text('サイズ（最大推定直径）: ${double.parse(asteroid['estimated_diameter']['meters']['estimated_diameter_max'].toString()).floor()} m'),
          Text('接近距離: ${double.parse(asteroid['close_approach_data'][0]['miss_distance']['kilometers'].toString()).floor()} km'),
          Text('相対速度: ${double.parse(asteroid['close_approach_data'][0]['relative_velocity']['kilometers_per_hour'].toString()).floor()} km/h'),

          FavoriteIndicator(asteroidData: asteroid)
          ],
        ),
      ),
    );
  }
}