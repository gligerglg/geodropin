import 'package:flutter/material.dart';

void showAlertOneButton(
    String title, String message, String buttonText, BuildContext context,onTap) {
  /*showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(10),

          title: new Text(title),
          elevation: 5,
          content: new Text(message),
          actions: <Widget>[
            new FlatButton(
                onPressed:onTap,
                child: new Text(
                  buttonText,
                  style: TextStyle(color: Colors.deepPurple),
                ))
          ],
        );
      });
*/





  AlertDialog dialog = new AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    content: new Container(
      width: 260.0,
      height: 230.0,
      decoration: new BoxDecoration(
        shape: BoxShape.rectangle,
        color: const Color(0xFFFFFF),
        borderRadius:
        new BorderRadius.all(new Radius.circular(32.0)),
      ),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // dialog top
          new Expanded(
            child: new Row(
              children: <Widget>[
                new Container(
                  // padding: new EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                  ),
                  child: new Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // dialog centre
          new Expanded(
            child: new Text(message)
          ),

          // dialog bottom
          new Expanded(
            child: new Container(
              padding: new EdgeInsets.all(16.0),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: new Text(
                buttonText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  showDialog(context: context, child: dialog);

}
