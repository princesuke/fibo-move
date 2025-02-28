import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/fibonacci_list_screen.dart';

void main() {
  // อ่านค่าจาก `dart-define`
  const String platformOverride = String.fromEnvironment(
    'PLATFORM_OVERRIDE',
    defaultValue: '',
  );

  TargetPlatform platform;

  if (kIsWeb) {
    // ใช้ค่าจาก dart-define เฉพาะ Web เท่านั้น
    if (platformOverride == 'ios') {
      platform = TargetPlatform.iOS;
    } else if (platformOverride == 'android') {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.linux; // Default ของ Web
    }
  } else {
    // ใช้ค่าจริงของอุปกรณ์ (Android / iOS)
    if (Platform.isIOS) {
      platform = TargetPlatform.iOS;
    } else if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.linux; // MacOS หรือ Windows ก็ถือเป็น Linux
    }
  }

  runApp(MyApp(platform: platform));
}

class MyApp extends StatelessWidget {
  final TargetPlatform platform;

  const MyApp({super.key, required this.platform});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibonacci List',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.system,
      themeMode: ThemeMode.light,
      home: FibonacciListScreen(platform: platform),
    );
  }
}
