import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:asteroid/services/favorite_indicator.dart';
import 'asteroid_detail_screen.dart';

class AsteroidListScreen extends ConsumerStatefulWidget {
  @override
  _AsteroidListScreenState createState() => _AsteroidListScreenState();//ウィジェットを作成している
}//AsteroidListScreenクラスが呼び出されたときに、createState()メソッドによって、この内部クラスである_AsteroidListScreenStateが生成されます。


//今日の日付を作成
String getCurrentDateFormatted() {
  DateTime now = DateTime.now();
  String formattedDate = "${now.year.toString().padLeft(4, "0")}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}";
  return formattedDate;
}

//一週間後の日付
String getDateOneWeekLater() {
  DateTime now = DateTime.now();
  DateTime oneWeekLater = now.add(Duration(days: 7));
  String formattedDate = "${oneWeekLater.year.toString().padLeft(4, '0')}-${oneWeekLater.month.toString().padLeft(2, '0')}-${oneWeekLater.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

//ウィジェットのStateを管理するクラス
class _AsteroidListScreenState extends ConsumerState<AsteroidListScreen> {
  final String apiKey = 'gpDvaeRnXH7WoZ293pqSyE8JqggfvtzjRxAyie7O'; // NASA APIのAPIキー
  List<dynamic> asteroids = [];
  bool isLoading = true;
  String cuurentDate = getCurrentDateFormatted();//today
  String oneWeekLater = getDateOneWeekLater();
  
  @override
  void initState() {
    super.initState();
    fetchAsteroids();
  }

  Future<void> fetchAsteroids() async {
    final url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$cuurentDate&end_date=$oneWeekLater&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

    // JSONデータをデバッグ出力
    print('APIから取得したJSONデータ: $data');

      setState(() {
        asteroids = data['near_earth_objects'][cuurentDate];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load asteroid data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小惑星追跡($cuurentDate~)'), //$oneWeekLater)'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: asteroids.length,
              itemBuilder: (context, index) {
                final asteroid = asteroids[index];
                return Card(
                  child: ListTile(
                    title: Text(asteroid['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // テキストを左揃えにする
                    children: [
                    // サイズ（最大推定直径）を取得
                    Text('サイズ（最大推定直径）: ${double.parse(asteroid['estimated_diameter']['meters']['estimated_diameter_max'].toString()).floor()} m'),
                    Text('接近距離: ${double.parse(asteroid['close_approach_data'][0]['miss_distance']['kilometers'].toString()).floor()} km'),
                    FavoriteIndicator(asteroidData: asteroid)
                    ],
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AsteroidDetailScreen(asteroid: asteroid),
                      )
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}