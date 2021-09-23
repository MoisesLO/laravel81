import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'datasearch.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.red,
      appBarTheme: AppBarTheme(
        color: Colors.red
      ),
    ),
    darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    title: 'Vue js',
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laravel 8 Es Documentacion'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  showSearch(context: context, delegate: DataSearch()))
        ],
      ),
      body: Home(),
    );
  }
}

