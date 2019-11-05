import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:search_cep/theme/theme.dart';
import 'package:search_cep/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(
              primarySwatch: MaterialColor(4280405747, {
                50: Color(0xffe7fafe),
                100: Color(0xffcff4fc),
                200: Color(0xff9eeafa),
                300: Color(0xff6edff7),
                400: Color(0xff3dd4f5),
                500: Color(0xff0dcaf2),
                600: Color(0xff0aa1c2),
                700: Color(0xff087991),
                800: Color(0xff055161),
                900: Color(0xff032830)
              }),
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Search Cep',
            theme: theme,
            home: new HomePage(),
          );
        });
  }
}
