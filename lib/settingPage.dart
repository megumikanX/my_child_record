import 'package:flutter/material.dart';

// 他のページ
class PageWidget extends StatelessWidget {
  final Color color;
  final String title;

  PageWidget({Key key, this.color, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            // Image(
            //   image: AssetImage('images/photo.png'),
            // ),
          ],
        ),
      ),
    );
  }
}