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

  Future<UserEntity> getCurrentUser() => repository.getCurrentUser();

  Future<void> logout() => repository.logout();

  Stream<List<TodoList>> todoLists(UserEntity user) {
    return repository.todoLists(user).map((entities) {
      return entities.map(TodoList.fromEntity).toList();
    });
  }

  Future<void> addTodoList(UserEntity user, TodoList todoList) =>
      repository.addTodoList(user, todoList);

  Future<void> updateTodoList(UserEntity user, TodoList todoList) =>
      repository.updateTodoList(user, todoList);

  Future<void> deleteTodoLists(UserEntity user, List<TodoList> todoLists) =>
      repository.deleteTodoLists(user, todoLists);

  Future<void> updateTodo(UserEntity user, TodoList todoList, Todo todo) =>
      repository.updateTodo(user, todoList, todo);

  Future<void> addTodo(UserEntity user, TodoList todoList, Todo todo) =>
      repository.addTodo(user, todoList, todo);

  Future<void> deleteTodos(UserEntity user, TodoList todoList, List<Todo> todos) =>
      repository.deleteTodos(user, todoList, todos);
}
