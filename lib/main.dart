import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasks_flutter_v2/repository/repository.dart';
import 'package:tasks_flutter_v2/routes.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

import 'generated/i18n.dart';
import 'screen/add.dart';
import 'screen/home.dart';
import 'screen/list_manager.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map _routes = <String, WidgetBuilder>{
    Routes.home: (BuildContext context) => Home(),
  };

  Route _getRoute(RouteSettings settings) {
    final Map map = settings.arguments;

    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case Routes.addTask:
            return Add(user: map['user'], todoList: map['todoList']);
            break;
          case Routes.editTask:
            return Add(user: map['user'], todoList: map['todoList'], todo: map['todo']);
            break;
          case Routes.manageLists:
            return ListManager(user: map['user']);
            break;
          default:
            // The other paths we support are in the routes table.
            return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TodoListProvider(
      repository: Repository(),
      child: MaterialApp(
        onGenerateTitle: (context) => S.of(context).appTitle,
        theme: _theme(),
        home: Home(),
        routes: _routes,
        onGenerateRoute: _getRoute,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }

  ThemeData _theme() {
    final Color accentColor = Colors.redAccent;
    return ThemeData(
        brightness: Brightness.dark,
        accentColor: accentColor,
        toggleableActiveColor: accentColor,
        textSelectionHandleColor: accentColor,
        cursorColor: accentColor);
  }
}
