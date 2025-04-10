import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_db_miner/views/screens/favorite.dart';
import 'package:quotes_db_miner/views/screens/home_screen.dart';
import 'package:quotes_db_miner/views/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
        GetPage(name: '/fav', page: () => FavoriteScreen()),
      ],
    );
  }
}
