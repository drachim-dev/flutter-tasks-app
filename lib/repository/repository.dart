import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
import 'package:tasks_flutter_v2/model/todo_entity.dart';
import 'package:tasks_flutter_v2/model/todo_list.dart';
import 'package:tasks_flutter_v2/model/todo_list_entity.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';
import 'package:tasks_flutter_v2/repository/todo_repository.dart';
import 'package:tasks_flutter_v2/repository/user_repository.dart';

class Repository {
  final UserRepository _userRepository =
      FirebaseUserRepository(FirebaseAuth.instance, GoogleSignIn());
  final TodoRepository _todoRepository = FirestoreTodoRepository(Firestore.instance);

  Future<UserEntity> loginAnonymously() => _userRepository.loginAnonymously();

  Future<UserEntity> loginViaGoogle() => _userRepository.loginViaGoogle();

  Future<UserEntity> getCurrentUser() => _userRepository.getCurrentUser();

  Future<void> logout() => _userRepository.logout();

  Future<void> addTodoList(UserEntity user, TodoList todoList) =>
      _todoRepository.addTodoList(user, todoList.toEntity());

  Future<void> updateTodoList(UserEntity user, TodoList todoList) =>
      _todoRepository.updateTodoList(user, todoList.toEntity());

  Future<void> deleteTodoLists(UserEntity user, List<TodoList> todoLists) => _todoRepository
      .deleteTodoLists(user, todoLists.map((todoList) => todoList.toEntity()).toList());

  Future<void> addTodo(UserEntity user, TodoList todoList, Todo todo) =>
      _todoRepository.addTodo(user, todoList.toEntity(), todo.toEntity());

  Future<void> updateTodo(UserEntity user, TodoList todoList, Todo todo) =>
      _todoRepository.updateTodo(user, todoList.toEntity(), todo.toEntity());

  Future<void> deleteTodos(UserEntity user, TodoList todoList, List<Todo> todos) => _todoRepository
      .deleteTodos(user, todoList.toEntity(), todos.map((todo) => todo.toEntity()).toList());

  Stream<List<TodoListEntity>> todoLists(
    UserEntity user,
  ) =>
      _todoRepository.todoLists(user);

  Stream<List<TodoEntity>> todosByList(UserEntity user, String listId) =>
      _todoRepository.todosByList(user, listId);

  Stream<TodoEntity> todo(UserEntity user, String id) => _todoRepository.todo(user, id);
}
