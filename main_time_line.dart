import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeLine',
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TimeLineSimple")),
      body: Container(child: ListView.builder(itemBuilder: _buildItem, itemCount: 20)),
    );
  }

  Widget _buildItem(BuildContext c, int i) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(border: BorderTimeLine(i)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Divider(color: Colors.grey.shade300, thickness: 40),
            Text("$i" * 6, style: TextStyle(color: Colors.black, fontSize: 16)),
            Text("abc\n" * Random().nextInt(10)),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ]),
        ));
  }
}

class BorderTimeLine extends BorderDirectional {
  int position;

  BorderTimeLine(this.position);

  double radius = 10;
  double margin = 20;
  Paint _paint = Paint()
    ..color = Color(0xFFDDDDDD)
    ..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection, BoxShape shape = BoxShape.rectangle, BorderRadius? borderRadius}) {
    if (position != 0) {
      canvas.drawLine(Offset(rect.left + margin + radius / 2, rect.top), Offset(rect.left + margin + radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), radius, _strokePaint());
    } else {
      canvas.drawLine(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), Offset(rect.left + margin + radius / 2, rect.bottom), _strokePaint());
      canvas.drawCircle(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), radius, _fillPaint());
      canvas.drawCircle(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), radius, _strokePaint());
      canvas.drawCircle(Offset(rect.left + margin + radius / 2, rect.top + radius * 2), radius / 2, _strokePaint());
    }
  }

  Paint _fillPaint() {
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
    return _paint;
  }

  Paint _strokePaint() {
    _paint.color = Color(0xFFDDDDDD);
    _paint.style = PaintingStyle.stroke;
    return _paint;
  }
}
