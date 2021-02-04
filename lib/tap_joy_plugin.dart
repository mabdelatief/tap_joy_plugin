
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
enum TapJoyConnectionResult {
  connected,
  disconnected
}
enum TapJoyContentState {
  contentReady,
  contentDidAppear,
  contentDidDisappear,
  contentRequestSuccess,
  contentRequestFail,
  userClickedAndroidOnly,
}

enum IOSATTAuthResult {
  notDetermined,
  restricted,
  denied,
  authorized,
  none,
  iOSVersionNotSupported,
  android
}

enum TapJoyBalanceResult {
  balanceRequestSuccess,
  balanceRequestFail
}
typedef void TJPlacementHandler(TapJoyContentState contentState,String placementName,String error,);
typedef void ConnectionResultHandler(TapJoyConnectionResult connectionResult);
// typedef void ContentStateHandler(TapJoyContentState contentState);
typedef void SpendCurrencyHandler(String currencyName,int amount,String error);
typedef void AwardCurrencyHandler(String currencyName,int amount,String error);
typedef void GetCurrencyBalanceHandler(String currencyName,int amount,String error);
typedef void EarnedCurrencyAlertHandler(String currencyName,int earnedAmount,String error);
const MethodChannel _channel =
const MethodChannel('tap_joy_plugin');
class TapJoyPlugin {


  static TapJoyPlugin shared = new TapJoyPlugin();
  final List<TJPlacement> placements = [];
  Future<bool> addPlacement(TJPlacement tjPlacement) async{
    placements.add(tjPlacement);
   return await _createPlacement(tjPlacement);
  }

  // event handlers
ConnectionResultHandler _connectionResultHandler;
// ContentStateHandler _contentStateHandler;
SpendCurrencyHandler _spendCurrencyHandler;
AwardCurrencyHandler _awardCurrencyHandler;
GetCurrencyBalanceHandler _getCurrencyBalanceHandler;
EarnedCurrencyAlertHandler _earnedCurrencyAlertHandler;

  void setConnectionResultHandler(ConnectionResultHandler handler) {
    _connectionResultHandler = handler;
  }
  void setSpendCurrencyHandler(SpendCurrencyHandler handler) {
    _spendCurrencyHandler = handler;
  }
  void setAwardCurrencyHandler(AwardCurrencyHandler handler) {
    _awardCurrencyHandler = handler;
  }
  void setGetCurrencyBalanceHandler(GetCurrencyBalanceHandler handler) {
    _getCurrencyBalanceHandler = handler;
  }
  void setEarnedCurrencyAlertHandler(EarnedCurrencyAlertHandler handler) {
    _earnedCurrencyAlertHandler = handler;
  }

  Future<bool> isConnected() async{
    return await _channel.invokeMethod("isConnected");
  }

  Future<IOSATTAuthResult> getIOSATTAuth()async{
    if (Platform.isIOS) {
      final String result = await _channel.invokeMethod("getATT");
      switch (result) {
        case "NotDetermined":
          return IOSATTAuthResult.notDetermined;
          break;
        case"Restricted":
          return IOSATTAuthResult.restricted;
          break;
        case"Denied":
          return IOSATTAuthResult.denied;
          break;
        case"Authorized":
          return IOSATTAuthResult.authorized;
          break;
        case"NOT":
          return IOSATTAuthResult.iOSVersionNotSupported;
          break;
        default:
          return IOSATTAuthResult.none;
          break;
      }
    } else {
      return IOSATTAuthResult.android;
    }
  }

  // constructor method
  TapJoyPlugin() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<bool> connect({@required String androidApiKey,@required String iOSApiKey,@required bool debug}) async {
    final bool connectionResult = await _channel.invokeMethod('connectTapJoy',<String, dynamic>{
      'androidApiKey': androidApiKey,
      "iOSApiKey": iOSApiKey,
      "debug": debug,

    });
    return connectionResult;
  }
  Future<void> setUserID({@required String userID}) async {
     await _channel.invokeMethod('setUserID',<String, dynamic>{
      'userID': userID,
    });
    return;
  }

  Future<bool> _createPlacement(TJPlacement tjPlacement) async {
      final result = await _channel.invokeMethod('createPlacement',<String, dynamic>{
        'placementName': tjPlacement.name,
      });
      return result;
  }


  Future<Null> _handleMethod(MethodCall call) async {
   switch(call.method) {
      case 'connectionSuccess':
        if (this._connectionResultHandler != null) {
    this._connectionResultHandler(TapJoyConnectionResult.connected);
        }
        break;
      case 'connectionFail':
        if (this._connectionResultHandler != null) {
          this._connectionResultHandler(TapJoyConnectionResult.disconnected);
        }
        break;
      case 'requestSuccess':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {

            tjPlacement._handler(TapJoyContentState.contentRequestSuccess,placementName,null);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'requestFail':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);
        String error = call.arguments["error"];
        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler(TapJoyContentState.contentRequestFail,placementName,error);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'contentReady':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler(TapJoyContentState.contentReady,placementName,null);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'contentDidAppear':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler(TapJoyContentState.contentDidAppear,placementName,null);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'clicked':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler(TapJoyContentState.userClickedAndroidOnly,placementName,null);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'contentDidDisAppear':
        String placementName = call.arguments["placementName"];
        TJPlacement tjPlacement = placements.firstWhere((element) => element.name == placementName,orElse: ()=> null);

        if (tjPlacement != null) {
          if (tjPlacement._handler != null) {
            tjPlacement._handler(TapJoyContentState.contentDidDisappear,placementName,null);
          } else {
            //TODO : Handler Null Error
          }
        }
        break;
      case 'onGetCurrencyBalanceResponse':
        int balance = call.arguments["balance"];
        String currencyName = call.arguments["currencyName"];
        String error = call.arguments["error"];
        if (this._getCurrencyBalanceHandler != null) {

          this._getCurrencyBalanceHandler(currencyName,balance,error);
        }
        break;
      case 'onSpendCurrencyResponse':
        int balance = call.arguments["balance"];
        String currencyName = call.arguments["currencyName"];
        String error = call.arguments["error"];
        if (this._spendCurrencyHandler != null) {

         this._spendCurrencyHandler(currencyName,balance,error);
        }
        break;
      case 'onAwardCurrencyResponse':
        int balance = call.arguments["balance"];
        String currencyName = call.arguments["currencyName"];
        String error = call.arguments["error"];
        if (this._awardCurrencyHandler != null) {
          this._awardCurrencyHandler(currencyName,balance,error);
        }
        break;
      case 'onEarnedCurrency':
        int earnedAmount = call.arguments["earnedAmount"];
        String currencyName = call.arguments["currencyName"];
        String error = call.arguments["error"];
        if (this._earnedCurrencyAlertHandler != null) {
          this._earnedCurrencyAlertHandler(currencyName,earnedAmount,error);
        }
        break;
      default:
        break;
    }
    return null;
  }

  Future<void> getCurrencyBalance() async {
    await _channel.invokeMethod('getCurrencyBalance');
}

  Future<void> spendCurrency(int amount) async {
    await _channel.invokeMethod('spendCurrency',<String, dynamic>{
      'amount': amount,
    });
  }

  Future<void> awardCurrency(int amount) async {
    await _channel.invokeMethod('awardCurrency',<String, dynamic>{
      'amount': amount,
    });
  }
}

class TJPlacement {
  final String name;
  TJPlacementHandler _handler;

 void setHandler(TJPlacementHandler myHandler) {
    _handler = myHandler;
  }


  TJPlacement({@required this.name}) {
    // TapJoyPlugin.shared.addPlacement(this);
  }

  Future<void> requestContent() async {
    await _channel.invokeMethod('requestContent',<String, dynamic>{
        'placementName': name,
      });
  }

  Future<void> showPlacement() async {
await _channel.invokeMethod('showPlacement',<String, dynamic>{
        'placementName': name,
      });
  }

}

class TJCurrencyResponse {
  final int balance;
  final int earnedAmount;
  final String currencyName;
  final String error;
  TJCurrencyResponse({@required this.earnedAmount,@required this.currencyName,@required this.balance,@required this.error});
}
