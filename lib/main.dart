import 'package:flutter/material.dart';
import 'package:flutter_application_mel/MyApp.dart';
import 'package:flutter_application_mel/result.dart';

void main() {
  runApp(const NaviPage());
}

class NaviPage extends StatefulWidget {
  const NaviPage({super.key});

  @override
  State<NaviPage> createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
  var items = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.fastfood),
      label: '오늘의 메뉴',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.check_box_outlined),
      label: '평가하기',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.bar_chart),
      label: '결과보기',
    ),
  ];

  dynamic page = const MyApp();
  var pages = [const MyApp(), const MyApp(), const Result()];
  var _index = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: page,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (value) {
            setState(() {
              page = pages[value];
              _index = value;
            });
          },
          items: items,
        ),
      ),
    );
  }
}
