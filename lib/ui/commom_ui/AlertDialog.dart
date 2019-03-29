import 'package:flutter/material.dart';

void showAlertOneButton(String title, String message, String buttonText,
    BuildContext context, onTap) {
  AlertDialog dialog = new AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20))),
    contentPadding: EdgeInsets.all(0),
    content: new Container(
      height: 200.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 20),
            child: new Text(
              "$title",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurple),
            ),
          ),
          new Expanded(
              child: new Padding(
            padding: EdgeInsets.all(20),
            child: new Text(
              "$message",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          )),
          new Row(
            children: <Widget>[
              new Expanded(
                child: InkWell(
                  child: new Container(
                      color: Colors.deepPurple,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: new Text(
                          "$buttonText",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  onTap: onTap,
                ),
              )
            ],
          )
        ],
      ),
    ),
  );

  showDialog(context: context, child: dialog);
}

void showAlertTwoButtons(String title, String message, String positiveTxt, String negativeTxt,
    BuildContext context, positiveCallBack, negativeCallback) {
  AlertDialog dialog = new AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20))),
    contentPadding: EdgeInsets.all(0),
    content: new Container(
      height: 200.0,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 20),
            child: new Text(
              "$title",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurple),
            ),
          ),
          new Expanded(
              child: new Padding(
                padding: EdgeInsets.all(20),
                child: new Text(
                  "$message",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )),
          new Row(
            children: <Widget>[
              new Expanded(
                child: InkWell(
                  child: new Container(
                      color: Colors.deepPurple,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: new Text(
                          "$positiveTxt",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  onTap: positiveCallBack,
                ),
              ),

              new Expanded(
                child: InkWell(
                  child: new Container(
                      color: Colors.deepPurple,
                      child: new Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: new Text(
                          "$negativeTxt",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  onTap: negativeCallback,
                ),
              )
            ],
          )
        ],
      ),
    ),
  );

  showDialog(context: context, child: dialog);
}
