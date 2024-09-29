import 'dart:async';
import 'package:flutter/material.dart';
import 'asteroid_list_screen.dart'; // メイン画面への遷移に使う

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // タイトル画面を3秒間表示した後、メイン画面に遷移
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AsteroidListScreen(), // メイン画面に遷移
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 74, 63, 160), // 背景色
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // アプリケーションのロゴやアイコン
            Icon(
              Icons.star, // ここでロゴやアイコンを設定（カスタム画像でもOK）
              size: 100.0,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            // アプリケーションのタイトル
            Text(
              'Asteroid Tracker',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // ローディングインジケータ
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
