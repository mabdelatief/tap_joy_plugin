package com.mahmoudabdellatief.tap_joy_plugin;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.tapjoy.TJActionRequest;
import com.tapjoy.TJAwardCurrencyListener;
import com.tapjoy.TJConnectListener;
import com.tapjoy.TJEarnedCurrencyListener;
import com.tapjoy.TJError;
import com.tapjoy.TJGetCurrencyBalanceListener;
import com.tapjoy.TJPlacement;
import com.tapjoy.TJPlacementListener;
import com.tapjoy.TJSpendCurrencyListener;
import com.tapjoy.Tapjoy;
import com.tapjoy.TapjoyConnectFlag;

import java.util.Hashtable;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** TapJoyPlugin */
public class TapJoyPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  static Activity activity;
  private Context context;
  Hashtable<String, TJPlacement> placements = new Hashtable<String, TJPlacement>();

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "tap_joy_plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();

  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {


    switch (call.method) {

      case "connectTapJoy":
        Tapjoy.setActivity(activity);
        final String tapjoySDKKey = call.argument("androidApiKey");
        final Boolean debug = call.argument("debug");
        Hashtable<String, Object> connectFlags = new Hashtable<String, Object>();
        connectFlags.put(TapjoyConnectFlag.ENABLE_LOGGING, "true");
        Tapjoy.setDebugEnabled(debug);
        boolean resulti = Tapjoy.connect(context, tapjoySDKKey, connectFlags, new TJConnectListener() {
          @Override
          public void onConnectSuccess() {

            channel.invokeMethod("connectionSuccess",null);
          }

          @Override
          public void onConnectFailure() {
            channel.invokeMethod("connectionFail",null);
          }
        });
        result.success(resulti);
        Tapjoy.setEarnedCurrencyListener(new TJEarnedCurrencyListener() {
          @Override
          public void onEarnedCurrency(String currencyName, int amount) {
            Hashtable<String, Object> getCurrencyResponse = new Hashtable<String, Object>();
            try {
              getCurrencyResponse.put("currencyName",currencyName);
              getCurrencyResponse.put("earnedAmount",amount);
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onEarnedCurrency",null);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            } }
        });
        break;
      case "setUserID":
        final String userID = call.argument("userID");
        Tapjoy.setUserID(userID);
        break;
      case "createPlacement":
        final String placementName = call.argument("placementName");
        TJPlacementListener placementListener = new TJPlacementListener() {
          @Override
          public void onRequestSuccess(final TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {


                channel.invokeMethod("requestSuccess",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }

          @Override
          public void onRequestFailure(TJPlacement tjPlacement, TJError tjError) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("requestFail",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }

          @Override
          public void onContentReady(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {


                channel.invokeMethod("contentReady",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }

          @Override
          public void onContentShow(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {
                channel.invokeMethod("contentDidAppear",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }

          @Override
          public void onContentDismiss(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {


                channel.invokeMethod("contentDidDisAppear",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }

          @Override
          public void onPurchaseRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s) {

          }

          @Override
          public void onRewardRequest(TJPlacement tjPlacement, TJActionRequest tjActionRequest, String s, int i) {

          }

          @Override
          public void onClick(TJPlacement tjPlacement) {
            final Hashtable<String, Object> myMap = new Hashtable<String, Object>();
            myMap.put("placementName",tjPlacement.getName());
            try {
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {


                channel.invokeMethod("clicked",myMap);
              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }
        };
        TJPlacement p = Tapjoy.getPlacement(placementName, placementListener);
        placements.put(placementName,p);
        result.success(p.isContentAvailable());
        break;
      case "requestContent":
        final String placementNameRequest = call.argument("placementName");
        final TJPlacement tjPlacementRequest = placements.get(placementNameRequest);

        if (tjPlacementRequest != null) {
          tjPlacementRequest.requestContent();

        } else {
          result.success(String.format("Placement with name %s NOT Found, please add placement first", placementNameRequest));
        }

        break;
      case "showPlacement":
        final String placementNameShow = call.argument("placementName");
        final TJPlacement tjPlacementShow = placements.get(placementNameShow);
        if (tjPlacementShow!= null) {
          if (tjPlacementShow.isContentAvailable()) {
            if (tjPlacementShow.isContentReady()) {
              tjPlacementShow.showContent();
            } else {
              result.success(String.format("Placement with name %s Content NOT Ready", placementNameShow));

            }
          } else {
            result.success(String.format("Placement with name %s NO content available", placementNameShow));

          }

        } else {
          result.success(String.format("Placement with name %s NOT Found, please add placement first", placementNameShow));
        }
        break;
      case "getCurrencyBalance":
        Tapjoy.getCurrencyBalance(new TJGetCurrencyBalanceListener(){
          Hashtable<String, Object> getCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onGetCurrencyBalanceResponse(String currencyName, int balance) {
            try {
              getCurrencyResponse.put("currencyName",currencyName);
              getCurrencyResponse.put("balance",balance);
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onGetCurrencyBalanceResponse",getCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }
          @Override
          public void onGetCurrencyBalanceResponseFailure(String error) {
            try {
              getCurrencyResponse.put("error",error);

              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onGetCurrencyBalanceResponse",getCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }
        });

        break;
      case "spendCurrency":
        final String amountToSpend = call.argument("amount");
        final int myAmountInt = Integer.parseInt(amountToSpend);
        Tapjoy.spendCurrency(myAmountInt, new TJSpendCurrencyListener() {
          Hashtable<String, Object> spendCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onSpendCurrencyResponse(String currencyName, int balance) {
            try {
              spendCurrencyResponse.put("currencyName",currencyName);
              spendCurrencyResponse.put("balance",balance);

              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onSpendCurrencyResponse",spendCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }

          @Override
          public void onSpendCurrencyResponseFailure(String error) {
            try {
              spendCurrencyResponse.put("error",error);


              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onSpendCurrencyBalanceResponse",spendCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }
        });

        break;

      case "awardCurrency":
        final String amountToAward = call.argument("amount");
        final int myAmountIntAward = Integer.parseInt(amountToAward);
        Tapjoy.awardCurrency(myAmountIntAward, new TJAwardCurrencyListener() {
          Hashtable<String, Object> awardCurrencyResponse = new Hashtable<String, Object>();
          @Override
          public void onAwardCurrencyResponse(String currencyName, int balance) {
            try {
              awardCurrencyResponse.put("currencyName",currencyName);
              awardCurrencyResponse.put("balance",balance);
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onAwardCurrencyResponse",awardCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }
          }

          @Override
          public void onAwardCurrencyResponseFailure(String error) {
            try {
              awardCurrencyResponse.put("error",error);
              TapJoyPlugin.activity.runOnUiThread(new Runnable() {@Override
              public void run() {

                channel.invokeMethod("onAwardCurrencyResponse",awardCurrencyResponse);

              }
              });
            } catch(final Exception e) {
              Log.e("Tapjoy", "Error " + e.toString());
            }

          }
        });

        break;
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull  ActivityPluginBinding binding) {
    TapJoyPlugin.activity = binding.getActivity();
  }


  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull  ActivityPluginBinding binding) {
    TapJoyPlugin.activity = binding.getActivity();
  }


  @Override
  public void onDetachedFromActivity() {

  }
}
