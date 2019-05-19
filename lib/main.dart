import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/repository/repository.dart';
import 'package:tasks_flutter_v2/routes.dart';
import 'package:tasks_flutter_v2/screen/add.dart';
import 'package:tasks_flutter_v2/screen/home.dart';
import 'package:tasks_flutter_v2/widget/todo_bloc_provider.dart';

main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Tasks';

  final Map _routes = <String, WidgetBuilder>{
    Routes.home: (BuildContext context) => Home(title: _title),
  };

  Route _getRoute(RouteSettings settings) {
    final Map map = settings.arguments;

    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case Routes.addTask:
            return Add(todoList: map['todoList']);
            break;
          case Routes.editTask:
            return Add(todoList: map['todoList'], todo: map['todo']);
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
        title: _title,
        theme: _theme(),
        home: Home(title: _title),
        routes: _routes,
        onGenerateRoute: _getRoute,
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
