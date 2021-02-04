import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tap_joy_plugin/tap_joy_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TJPlacement myPlacement;

  TJPlacement myPlacement2;
  @override
  void initState() {
    super.initState();
    TapJoyPlugin.shared.connect(androidApiKey: "IBuJzgu8TbGfEB2aC--ZGgECiwfJjSSMq7XrzTz2Uri3tzWUi0mmUTiwY8nT", iOSApiKey: "U6HG8d8zSOC-0gZYNNdMRwEBCKsMrykrl36QNJ1fTt3gFcDi3MmGneB3W4sZ", debug: true);
    myPlacement = TJPlacement(name: "LevelComplete");
    myPlacement.setHandler((contentState,name,error) {
        switch(contentState) {
          case TapJoyContentState.contentReady:
          // TODO: Handle this case.
            print("7oka contentReady"+ name + error.toString());
            break;
          case TapJoyContentState.contentDidAppear:
          // TODO: Handle this case.
            print("7oka contentDidAppear " + name+ error.toString());
            break;
          case TapJoyContentState.contentDidDisappear:
          // TODO: Handle this case.
            print("7oka contentDidDisAppear"+ name + error.toString());
            break;
          case TapJoyContentState.contentRequestSuccess:
          // TODO: Handle this case.
            print("7oka contentRequestSuccess"+ name + error.toString());
            break;
          case TapJoyContentState.contentRequestFail:
          // TODO: Handle this case.
            print("7oka contentRequestFail"+ name + error.toString());
            break;
          case TapJoyContentState.userClicked:
          // TODO: Handle this case.
            print("7oka userClicked"+ name + error.toString());
            break;
        }
      }
    );

    TapJoyPlugin.shared.addPlacement(myPlacement).then((value) {
      print("7oka add Placement return = " + value.toString());
    });
    TapJoyPlugin.shared.setGetCurrencyBalanceHandler((currencyName, amount, error) {
      print("7oka " + currencyName.toString() + " " + amount.toString() + " " + error.toString());
    });
    TapJoyPlugin.shared.setAwardCurrencyHandler((currencyName, amount, error) {
      print("7oka " +currencyName.toString() + " " + amount.toString() + " " + error.toString());
    });
    TapJoyPlugin.shared.setSpendCurrencyHandler((currencyName, amount, error) {
      print("7oka " +currencyName.toString() + " " + amount.toString() + " " + error.toString());
    });
    TapJoyPlugin.shared.setConnectionResultHandler((result) {
      switch (result) {

        case TapJoyConnectionResult.connected:
          // TODO: Handle this case.
        print(" 7oka connected");
          break;
        case TapJoyConnectionResult.disconnected:
          // TODO: Handle this case.
          print(" 7oka Disconnected");
          break;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                child: Text("request content"),
                onPressed: myPlacement.requestContent,),
              ElevatedButton(
                child: Text("show Placement"),
                onPressed: myPlacement.showPlacement,),
              ElevatedButton(
                child: Text("get balance"),
                onPressed: TapJoyPlugin.shared.getCurrencyBalance,),
              ElevatedButton(
                child: Text("award balance"),
                onPressed: ()
                {
                  TapJoyPlugin.shared.awardCurrency(15);
                } ,),
              ElevatedButton(
                child: Text("spend balance"),
                onPressed:  ()
                {
                  TapJoyPlugin.shared.spendCurrency(5);
                } ,),
            ],
          ),
        ),
      ),
    );
  }
}
