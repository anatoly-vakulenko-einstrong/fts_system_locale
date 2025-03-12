import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fts_system_locale/fts_system_locale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

const methodChannel = MethodChannel('com.example.example');

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _locales = [];
  late String _locale;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _locale = Platform.localeName;
    debugPrint('init locale: $_locale');
    _locales.add(_locale);
    _locales.addAll([
      'en_US',
      'en_UK',
      'en_GB',
      'fr_FR',
      'en_UA',
      'bn_IN',
      'uk_UA',
    ].where((i) => i != _locale));
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    debugPrint('didChangeLocales: $locales');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        // Fts.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        appBar: AppBar(title: Text(_locale)),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: _locale,
                items: _locales
                    .map((e) =>
                        DropdownMenuItem<String>(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  FtsSystemLocale().setLocale(value).then((_) {
                    debugPrint('after setLocale: ${Platform.localeName}');
                  });
                  setState(() {
                    _locale = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
