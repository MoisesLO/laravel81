import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'detail.dart';

const int maxFailedLoadAttempts = 3;

class CardList extends StatefulWidget {
  final String? number;
  final String? title;
  final String? subtitle;
  final String? contenido;
  const CardList(
      {Key? key, this.number, this.title, this.subtitle, this.contenido})
      : super(key: key);

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-5852042324891789/7316189605',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 63,
              height: 63,
              child: CircleAvatar(
                // backgroundColor: Colors.green,
                radius: 25,
                child: Image.asset('assets/img/laravel_icon.png'),
              ),
            ),
            Flexible(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${widget.title}',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  '${widget.subtitle}',
                  style: TextStyle(fontSize: 11, color: Colors.black45),
                )
              ],
            ))
          ],
        ),
      ),
      onTap: () {
        _showInterstitialAd();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Detail(
                    title: '${widget.title}',
                    contenido: '${widget.contenido}')));
      },
    );
  }
}
