import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'colors.dart';
import 'signup.dart';
import 'favorites.dart';
import 'search.dart';
import 'mypage.dart';
import 'ranking.dart';
import 'item.dart';
import 'profile.dart';

class MallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MallApp',
      home: HomePage(),
      initialRoute: '/login',
      routes:{
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/favorite': (context) => FavoritePage(),
        '/signup': (context) => SignUp(),
        '/search': (context) => SearchPage(),
        '/ranking': (context) => RankingPage(),
        '/mypage': (context) => MyPage(),
        '/item': (context) => AddItem(),
        '/profile': (context) => ProfilePage(),
        '/mallmain':(context) => MallApp(),
      },
      onGenerateRoute: _getRoute,
      theme: _kShrineTheme,
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme(){
  final ThemeData base = ThemeData.light();
  return base.copyWith( // copyWith() returns an instance of the widget that matches the instance it's called on, but with the specified values replaced
    accentColor: kShrineBrown900,
    primaryColor: null,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: null,
      textTheme: ButtonTextTheme.normal,
    ),
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      color: Colors.white,
    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base){
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
      fontSize: 13.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 8.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: Colors.black,
    bodyColor: Colors.black,
  );
}