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
    myPlacement.setHandler((contentState) {
        switch(contentState) {
          case TapJoyContentState.contentReady:
          // TODO: Handle this case.
            print("7oka contentReady");
            break;
          case TapJoyContentState.contentDidAppear:
          // TODO: Handle this case.
            print("7oka contentDidAppear");
            break;
          case TapJoyContentState.contentDidDisappear:
          // TODO: Handle this case.
            print("7oka contentDidDisAppear");
            break;
          case TapJoyContentState.contentRequestSuccess:
          // TODO: Handle this case.
            print("7oka contentRequestSuccess");
            break;
          case TapJoyContentState.contentRequestFail:
          // TODO: Handle this case.
            print("7oka contentRequestFail");
            break;
          case TapJoyContentState.userClicked:
          // TODO: Handle this case.
            print("7oka userClicked");
            break;
        }
      }
    );
    TapJoyPlugin.shared.addPlacement(myPlacement).then((value) {
      print("add Placement return = " + value.toString());
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
            ],
          ),
        ),
      ),
    );
  }
}
