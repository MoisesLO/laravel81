import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Detail extends StatefulWidget {
  final String? title;
  final String? contenido;
  const Detail({Key? key, this.title, this.contenido}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
      ),
      body: ListView(
        children: [Padding(
          padding: EdgeInsets.all(10),
          child: HtmlWidget('${widget.contenido}',customStylesBuilder: (element) {

            // Vinculos verde
            if (element.classes.contains('link')) {
              return {'color': '#ff2d20'};
            }
            if (element.classes.contains('important')) {
              return {'color': '#0782B1'};
            }
            if (element.classes.contains('keyword')) {
              return {'color': '#055472'};
            }
            if (element.classes.contains('class-name')) {
              return {'color': '#CA473F'};
            }
            if (element.classes.contains('variable')) {
              return {'color': '#0782B1'};
            }
            if (element.classes.contains('function')) {
              return {'color': '#CA473F'};
            }
            if (element.classes.contains('property')) {
              return {'color': '#981D15'};
            }
            if (element.classes.contains('single-quoted-string')) {
              return {'color': '#669900'};
            }
            if (element.classes.contains('single-quoted-string.s')) {
              return {'color': '#669900'};
            }
            if (element.classes.contains('language-java')) {
              return {'color': '#FC929E'};
            }



            if (element.localName == 'code') {
              return {'font-weight': '550'};
            }

            // if (element.localName == 'blockquote') {
            //   return {'background-color': '#f5f7f9', 'padding': '15px'};
            // }



            return null;
          },),
        )],
      )
    );
  }
}
