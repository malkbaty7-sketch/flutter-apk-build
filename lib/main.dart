import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:katib/app.dart';
import 'package:katib/core/theme/app_theme.dart';
import 'package:katib/core/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة النظام
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // تهيئة الوضع الداكن/الفاتح حسب نظام الجهاز
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
  
  runApp(
    const ProviderScope(
      child: KatibApp(),
    ),
  );
}

/// التطبيق الرئيسي
class KatibApp extends StatelessWidget {
  const KatibApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
      locale: const Locale('ar', 'AE'), // اللغة الافتراضية
      home: const App(),
    );
  }
}
