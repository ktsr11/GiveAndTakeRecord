import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'body.dart';
import './addItem.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String _title = 'GiAnTaRec';

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      /* 앱별 현지화 */
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko'),  //한국 언어지원, 예) 달력이 한글화가 된다.  
      ],
      title: _title,
      home: MotherTabPage(),
      routes: {
        AddItemScreen.routeName: (context) => AddItemScreen()
      },
    );
  }
}