import 'package:flutter/material.dart';
import 'package:gen_bloc_code/gen_api_from_config_page.dart';
import 'package:gen_bloc_code/gen_api_page.dart';
import 'package:gen_bloc_code/gen_model_from_config_page.dart';
import 'package:gen_bloc_code/gen_model_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widgets is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages = [];
  int _currentIndex = 0;

  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pages = [
      GenApiFromConfigPage(),
      GenModelFromConfigPage(),
      GenApiPage(),
      GenModelPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          pageController.jumpToPage(index);
        },
        iconSize: 26,
        currentIndex: _currentIndex,
        selectedIconTheme: const IconThemeData(
            // color: Colors.green,
            ),
        unselectedIconTheme: const IconThemeData(
            // color: Colors.black12,
            ),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black38,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'API Config',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_outlined),
            label: 'Model config',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'API',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_outlined),
            label: 'Model',
          ),
        ],
      ),
    );
  }
}
