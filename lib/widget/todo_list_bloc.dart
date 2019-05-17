import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/repository/repository.dart';

class TodoListBloc {
  final Repository repository;

  TodoListBloc({@required this.repository});

  Future<UserEntity> loginAnonymously() => repository.loginAnonymously();

  Future<UserEntity> loginViaGoogle() => repository.loginViaGoogle();

  Future<void> logout() => repository.logout();

  Stream<List<TodoList>> get todoLists {
    return repository.todoLists().map((entities) => entities.map(TodoList.fromEntity).toList());
  }

  Future<void> addTodoList(TodoList todoList) => repository.addTodoList(todoList);

  Future<void> updateTodoList(TodoList todoList) => repository.updateTodoList(todoList);

  Future<void> deleteTodoLists(List<TodoList> todoLists) => repository.deleteTodoLists(todoLists);

  Future<void> updateTodo(TodoList todoList, Todo todo) => repository.updateTodo(todoList, todo);

  Future<void> addTodo(TodoList todoList, Todo todo) => repository.addTodo(todoList, todo);

  Future<void> deleteTodos(TodoList todoList, List<Todo> todos) =>
      repository.deleteTodos(todoList, todos);
}
