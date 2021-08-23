import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

final String Interticial = 'ca-app-pub-5852042324891789/1270549871';
final String banner = 'ca-app-pub-5852042324891789/3742275323';

var data;
List _items = [];
InterstitialAd? _interstitialAd;

void _createInterstitialAd() async {
  await InterstitialAd.load(
      adUnitId: 'ca-app-pub-5852042324891789/1270549871',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ));
}

void _showInterstitialAd() async {
  if (_interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  await _interstitialAd!.show();
  _interstitialAd = null;
}

final BannerAd myBanner = BannerAd(
  adUnitId: 'ca-app-pub-5852042324891789/3742275323',
  size: AdSize.banner,
  request: AdRequest(),
  listener: BannerAdListener(),
);

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Laravel 8',
    theme: ThemeData(primaryColor: Colors.red),
    darkTheme: ThemeData.dark(),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> readJson() async {
    final String response =
    await rootBundle.loadString('assets/json/data.json');
    final datos = await json.decode(response);
    setState(() {
      _items = datos;
      data = datos;
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
    myBanner.load();
    _createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Laravel 8 Offline'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    showSearch(context: context, delegate: DataSearch()))
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    child: AdWidget(
                      ad: myBanner,
                    ),
                    width: myBanner.size.width.toDouble(),
                    height: myBanner.size.height.toDouble(),
                  )),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return Ads();
                  } else {
                    return ExpansionTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.deepOrange,
                        child: Text('${index + 1}'),
                      ),
                      title: Text('${_items[index]['titulo']}'),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: _items[index].length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  AssetImage('assets/img/laravel1.png'),
                                ),
                                title: Text('${_items[index]['items'][i]['titulo']}'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Detail(
                                              subtitle: _items[index]['items'][i]
                                              ['titulo'],
                                              contenido: _items[index]['items'][i]
                                              ['contenido'])));
                                },
                              );
                            })
                      ],
                    );
                  }

                })
          ],
        )
    );
  }
}

class Ads extends StatelessWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Text(''),
    );
  }
}

class Detail extends StatefulWidget {
  final String subtitle;
  final String contenido;

  const Detail({Key? key, this.subtitle = '', this.contenido = ''})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();
    _showInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subtitle), actions: [
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () =>
                showSearch(context: context, delegate: DataSearch()))
      ]),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: HtmlWidget(widget.contenido),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
          )
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('build Result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var temporal = [];
    var temp = [];
    for (int i = 0; i < data.length; i++) {
      for (int h = 0; h < data[i]['items'].length; h++) {
        // temporal.insert(i,data[i]['items'][h]['titulo']);
        temporal.add(data[i]['items'][h]);
        // print(data[i]['items'][h]['titulo']);
      }
    }

    temp = temporal
        .where((note) => note['contenido'].toLowerCase().contains(query))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xf5495FF),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: AssetImage('assets/img/laravel1.png'),
              ),
            ),
            title: Text(temp[index]['titulo']),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail(
                          subtitle: temp[index]['titulo'],
                          contenido: temp[index]['contenido'])));
            },
          ),
        );
      },
      itemCount: temp.length,
    );
  }
}
