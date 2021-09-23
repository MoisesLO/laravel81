import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'detail.dart';
import 'carditem.dart';

class DataSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
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
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('build Result');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var _items = [];
    var temporal = [];
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString("assets/json/laravel88.json"),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _items = json.decode(snapshot.data);
          temporal = _items
              .where((note) => note['title'].toLowerCase().contains(query))
              .toList();
          if (_items.length == temporal.length) {
            return Text('');
          } else {
            return ListView.builder(
              itemCount: temporal.length,
              itemBuilder: (context, int index) {
                return CardList(
                  title: temporal[index]['title'],
                  number: '${index + 1}',
                  contenido: temporal[index]['contenido'],
                );
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
