import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'detail.dart';
import 'carditem.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

var _items;

class _HomeState extends State<Home> {
  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;
  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: AdRequest(),
      adUnitId: 'ca-app-pub-5852042324891789/4041151393',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingAnchoredBanner) {
      _loadingAnchoredBanner = true;
      _createAnchoredBanner(context);
    }
    return SafeArea(
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("assets/json/laravel88.json"),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                _items = json.decode(snapshot.data);
                // print(_items.length);
                return ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      child: CardList(
                        title: _items[index]['title'],
                        subtitle: _items[index]['subtitle'],
                        number: '${index + 1}',
                        contenido: _items[index]['contenido'],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Detail(
                                      title: '${_items[index]['title']}',
                                      contenido:
                                          '${_items[index]['contenido']}',
                                    )));
                      },
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_anchoredBanner != null)
            Container(
              // color: Colors.red,
              width: _anchoredBanner!.size.width.toDouble(),
              height: _anchoredBanner!.size.height.toDouble(),
              child: AdWidget(ad: _anchoredBanner!),
            ),
        ],
      ),
    );
  }
}
