# tap_joy_plugin

Flutter Plugin for [TapJoy](https://www.tapjoy.com/) SDK - Supports Android & iOS
This Plugin Does NOT Support TapJoy purchases or Push Notifications.

## info.plist changes
[TapJoy](https://www.tapjoy.com/) is enrolled as a network partner in Apple’s SKAdNetwork. Add Tapjoy's network ID to your app’s ```info.plist``` file along with the IDs of the DSP partners listed below:

```bash
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>ecpz2srf59.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>7ug5zh24hu.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>9t245vhmpl.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>prcb7njmu6.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>5lm9lj6jb7.skadnetwork</string>
    </dict>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>578prtvx9j.skadnetwork</string>
    </dict>
  </array>
```
iOS 14.0 or higher required App Tracking Authorization from the user.
add the following lines to ```info.plist``` file.
```bash
<key>NSUserTrackingUsageDescription</key>
<string>This allows us to deliver personalized ads for you.</string>
```
## AndroidManifest changes

The following permissions are needed:

- INTERNET
- ACCESS_NETWORK_STATE
- ACCESS_WIFI_STATE (optional)

add the following permissions to your ```AndroidManifest.xml``` file: 
```bash
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
  <uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
```
add the following activities to the ```AndroidManifest.xml``` file in the Application block:
```bash
<activity
  android:name="com.tapjoy.TJAdUnitActivity"
  android:configChanges="orientation|keyboardHidden|screenSize"
  android:hardwareAccelerated="true"
  android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" />
<activity
  android:name="com.tapjoy.TJContentActivity"
  android:configChanges="orientation|keyboardHidden|screenSize"
  android:theme="@android:style/Theme.Translucent.NoTitleBar"
  android:hardwareAccelerated="true" />
```
As part of your Google Play Services integration, you will have to add the following:
```bash
<meta-data
  android:name="com.google.android.gms.version"
  android:value="@integer/google_play_services_version" />
```
## Usage

### Connect to TapJoy

```dart
TapJoyPlugin.shared.connect(androidApiKey: “your-tapjoy-android-key”,
iOSApiKey:"your-tapjoy-iOS-key",debug: true);
```
### Set Connection Result handler

```dart
    TapJoyPlugin.shared.setConnectionResultHandler((result) {
      switch (result) {
        case TapJoyConnectionResult.connected:
          // TODO: Handle this case.
          break;
        case TapJoyConnectionResult.disconnected:
          // TODO: Handle this case.
          break;
      }

    });
```

### Get iOS App Tracking Authorization

```dart
  TapJoyPlugin.shared.getIOSATTAuth().then((value) {
      switch(value) {

        case IOSATTAuthResult.notDetermined:
           // TODO: Handle this case.
          break;
        case IOSATTAuthResult.restricted:
             // TODO: Handle this case.
          break;
        case IOSATTAuthResult.denied:
            // TODO: Handle this case.
          break;
        case IOSATTAuthResult.authorized:
             // TODO: Handle this case.
          break;
        case IOSATTAuthResult.none:
             // TODO: Handle this case.
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
            // TODO: Handle this case.
          break;
        case IOSATTAuthResult.android:
            // TODO: Handle this case.
      }
    });
```

### Set User ID

```dart
     TapJoyPlugin.shared.setUserID(userID: "user_id");

```
### Create Placement

```dart
  TJPlacement placement = TJPlacement(name: "TapJoyPlacementName");

```
### Create and set handler for placement

```dart
TJPlacementHandler handler = (contentState,name,error) {
      switch(contentState) {
        case TapJoyContentState.contentReady:
        // TODO: Handle this case.
          break;
        case TapJoyContentState.contentDidAppear:
        // TODO: Handle this case.
          break;
        case TapJoyContentState.contentDidDisappear:
        // TODO: Handle this case.
          break;
        case TapJoyContentState.contentRequestSuccess:
        // TODO: Handle this case.
          break;
        case TapJoyContentState.contentRequestFail:
        // TODO: Handle this case.
          break;
        case TapJoyContentState.userClickedAndroidOnly:
        // TODO: Handle this case.
          break;
      }
    };



  placement.setHandler(handler);
```
### Request Content

```dart
  await placement.requestContent();
```

### Show Placement Content

```dart
  await placement.showPlacement();
```

### Set Currency Balance Response Handler

```dart
  TapJoyPlugin.shared.setGetCurrencyBalanceHandler((currencyName, 
amount, error) {  });

```
### Get User Balance

```dart
  await TapJoyPlugin.shared.getCurrencyBalance();
```
### Set Award currency response handler

```dart
  TapJoyPlugin.shared.setAwardCurrencyHandler((currencyName, 
amount, error) {   });
```

### Award Currency 

```dart
  TapJoyPlugin.shared.awardCurrency(int amount);
```
### Set Spend Currency response handler 

```dart
  TapJoyPlugin.shared.setSpendCurrencyHandler((currencyName,
 amount, error) {   });
```
### Spend Currency 

```dart
  TapJoyPlugin.shared.spendCurrency( int amount );
```


## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[BSD](https://github.com/mabdelatief/tap_joy_plugin/blob/master/LICENSE)