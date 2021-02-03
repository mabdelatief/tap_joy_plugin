import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tap_joy_plugin/tap_joy_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('tap_joy_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await TapJoyPlugin.platformVersion, '42');
  });
}
