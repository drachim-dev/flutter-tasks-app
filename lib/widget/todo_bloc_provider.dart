import 'package:flutter/material.dart';
import 'package:tasks_flutter_v2/repository/repository.dart';
import 'package:tasks_flutter_v2/widget/todo_list_bloc.dart';

class TodoListProvider extends InheritedWidget {
  final TodoListBloc todoListBloc;
  final Repository repository;

  TodoListProvider({
    Key key,
    TodoListBloc todoListBloc,
    @required this.repository,
    Widget child,
  })  : todoListBloc = todoListBloc ?? TodoListBloc(repository: repository),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TodoListBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(TodoListProvider) as TodoListProvider).todoListBloc;
}
