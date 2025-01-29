import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


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

class AsteroidService {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  String currentDate = getCurrentDateFormatted();//today
  String oneWeekLater = getDateOneWeekLater();

  Future<Map<String, dynamic>> fetchAsteroids() async {
    final url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$currentDate&end_date=$oneWeekLater&api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

 // ステータスコードが200（成功）の場合、レスポンスをパース
  if (response.statusCode == 200) {
    // レスポンスデータを確認するためのデバッグ用コード
    if (kDebugMode) {
      print('APIレスポンス: ${response.body}');
    }
    
    // JSONをデコードして返す
    return json.decode(response.body);
  } else {
    // エラーが発生した場合は例外をスロー
    throw Exception('Failed to load asteroid data');
  }
 }
}

