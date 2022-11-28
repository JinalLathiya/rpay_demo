import 'package:flutter/material.dart';
import 'Views/details _page.dart';
import 'Views/home_page.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routes: {
        "/": (context) => const HomePage(),
        "detail_page": (context) => const DetailsPage(),
      },
    );
  }
}

