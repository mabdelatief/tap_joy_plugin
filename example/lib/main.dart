import 'package:flutter/material.dart';
import 'package:tap_joy_plugin/tap_joy_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TJPlacement myPlacement;
  TJPlacement myPlacement2;
  String contentStateText = "";
  String connectionState  = "";
  String iOSATTAuthResult  = "";
  String balance = "";
  TJPlacementHandler handler;
  @override
  void initState() {
    super.initState();
    TapJoyPlugin.shared.connect(androidApiKey: "IBuJzgu8TbGfEB2aC--ZGgECiwfJjSSMq7XrzTz2Uri3tzWUi0mmUTiwY8nT", iOSApiKey: "U6HG8d8zSOC-0gZYNNdMRwEBCKsMrykrl36QNJ1fTt3gFcDi3MmGneB3W4sZ", debug: true);
    handler  = (contentState,name,error) {
      switch(contentState) {
        case TapJoyContentState.contentReady:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content Ready for placement :  $name";
          });
          break;
        case TapJoyContentState.contentDidAppear:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content Did Appear for placement :  $name";
          });
          break;
        case TapJoyContentState.contentDidDisappear:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content Did Disappear for placement :  $name";
          });
          break;
        case TapJoyContentState.contentRequestSuccess:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content Request Success for placement :  $name";
          });
          break;
        case TapJoyContentState.contentRequestFail:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content Request Fail + $error for placement :  $name";
          });
          break;
        case TapJoyContentState.userClicked:
        // TODO: Handle this case.
          setState(() {
            contentStateText = "Content User Clicked for placement :  $name";
          });
          break;
      }
    };
    myPlacement = TJPlacement(name: "LevelComplete");
    myPlacement.setHandler(handler);
    myPlacement2 = TJPlacement(name: "Placement02");
    myPlacement2.setHandler(handler);

    TapJoyPlugin.shared.addPlacement(myPlacement);
    TapJoyPlugin.shared.addPlacement(myPlacement2);
    TapJoyPlugin.shared.setGetCurrencyBalanceHandler((currencyName, amount, error) {
      setState(() {
        balance = "Currency Name: " + currencyName.toString() + " Amount:  " + amount.toString() + " Error:" + error.toString();
      });
    });
    TapJoyPlugin.shared.setAwardCurrencyHandler((currencyName, amount, error) {
      setState(() {
        balance = "Currency Name: " + currencyName.toString() + " Amount:  " + amount.toString() + " Error:" + error.toString();
      });});
    TapJoyPlugin.shared.setSpendCurrencyHandler((currencyName, amount, error) {
      setState(() {
        balance = "Currency Name: " + currencyName.toString() + " Amount:  " + amount.toString() + " Error:" + error.toString();
      }); });
    TapJoyPlugin.shared.setConnectionResultHandler((result) {
      switch (result) {

        case TapJoyConnectionResult.connected:
          // TODO: Handle this case.
        setState(() {
          connectionState = "Connected";
        });
          break;
        case TapJoyConnectionResult.disconnected:
          // TODO: Handle this case.
          setState(() {
            connectionState = "Disconnected";
          });
          break;
      }

    });
  }

  Future<bool> printCheck()async{
    return await TapJoyPlugin.shared.isConnected();
  }
  Future<String> getAuth() async {
    TapJoyPlugin.shared.getIOSATTAuth().then((value) {
      switch(value) {

        case IOSATTAuthResult.notDetermined:
         setState(() {
           iOSATTAuthResult = "Not Determined";
         });
          break;
        case IOSATTAuthResult.restricted:
          setState(() {
            iOSATTAuthResult = "Restricted ";
          });
          break;
        case IOSATTAuthResult.denied:
          setState(() {
            iOSATTAuthResult = "Denied ";
          });
          break;
        case IOSATTAuthResult.authorized:
          setState(() {
            iOSATTAuthResult = "Authorized ";
          });
          break;
        case IOSATTAuthResult.none:
          setState(() {
            iOSATTAuthResult = "Error ";
          });
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
          setState(() {
            iOSATTAuthResult = "IOS Version Not Supported ";
          });
          break;
        case IOSATTAuthResult.android:
          setState(() {
            iOSATTAuthResult = "on Android";
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TapJoy Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text("Connection State : $connectionState"),
              ElevatedButton(
                child: Text("get iOS App Tracking Auth"),
                onPressed: getAuth,),
              Text("IOS Auth Result : $iOSATTAuthResult"),
              ElevatedButton(
                child: Text("request content for Placement 001"),
                onPressed: myPlacement.requestContent,),
              ElevatedButton(
                child: Text("request content for Placement 002"),
                onPressed: myPlacement2.requestContent,),
              Text("Content State : $contentStateText"),
              ElevatedButton(
                child: Text("show Placement 001"),
                onPressed: myPlacement.showPlacement,),
              ElevatedButton(
                child: Text("show Placement 002"),
                onPressed: myPlacement2.showPlacement,),
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

              Text("Balance Response : $balance"),
            ],
          ),
        ),
      ),
    );
  }
}
