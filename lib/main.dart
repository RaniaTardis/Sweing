import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_sweing_app/core/app_localizations.dart';
import 'package:my_sweing_app/core/app_theme.dart';
import 'package:my_sweing_app/core/locale_provider.dart';
import 'package:my_sweing_app/features/shop/screens/welcome_screen.dart';

void main() {
  runApp(const WarradApp());
}

class WarradApp extends StatefulWidget {
  const WarradApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    context.findAncestorStateOfType<_WarradAppState>()?.setLocale(locale);
  }

  static LocaleProvider? providerOf(BuildContext context) {
    return context.findAncestorStateOfType<_WarradAppState>()?._localeProvider;
  }

  @override
  State<WarradApp> createState() => _WarradAppState();
}

class _WarradAppState extends State<WarradApp> {
  final LocaleProvider _localeProvider = LocaleProvider();

  @override
  void initState() {
    super.initState();
    _localeProvider.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _localeProvider.dispose();
    super.dispose();
  }

  void setLocale(Locale locale) {
    _localeProvider.setLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warrad Fashion',
      theme: AppTheme.lightTheme,
      locale: _localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
