import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asteroid/screens/splash_screen.dart';


void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小惑星追跡',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

/*
class AsteroidListScreen extends StatefulWidget {
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


//画面ウィジェット
class _AsteroidListScreenState extends State<AsteroidListScreen> {
  final String apiKey = 'gpDvaeRnXH7WoZ293pqSyE8JqggfvtzjRxAyie7O'; // NASA APIのAPIキー
  List<dynamic> asteroids = [];
  bool isLoading = true;
  String cuurentDate = getCurrentDateFormatted();//today
  String oneWeekLater = getDateOneWeekLater();
  //String startDate = '2024-09-10'; 
  //String endDate = '2030-09-14'; // 終了日

  @override
  void initState() {
    super.initState();
    fetchAsteroids();
    //loadFavorites(); // お気に入りをロード
  }

  Future<void> fetchAsteroids() async {
    final url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$cuurentDate&end_date=$oneWeekLater&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
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
        title: Text('小惑星追跡($cuurentDate~$oneWeekLater)'),
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
                    subtitle: Text(
                        '接近日時: ${asteroid['close_approach_data'][0]['close_approach_date']}\n'
                        'サイズ（最大推定直径）: ${asteroid['estimated_diameter']['kilometers']['estimated_diameter_max']} km\n'
                        '接近距離: ${asteroid['close_approach_data'][0]['miss_distance']['kilometers']} km\n'
                        '相対速度: ${asteroid['close_approach_data'][0]['relative_velocity']['kilometers_per_hour']} km/h'),
                  ),
                );
              },
            ),
    );
  }
}
*/
