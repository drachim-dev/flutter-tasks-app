import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tasks_flutter_v2/model/todo.dart';
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

  Future<void> addTodoList(TodoList todoList) => _todoRepository.addTodoList(todoList.toEntity());

  Future<void> updateTodoList(TodoList todoList) =>
      _todoRepository.updateTodoList(todoList.toEntity());

  Future<void> deleteTodoLists(List<TodoList> todoLists) =>
      _todoRepository.deleteTodoLists(todoLists.map((todoList) => todoList.toEntity()).toList());

  Future<void> addTodo(TodoList todoList, Todo todo) =>
      _todoRepository.addTodo(todoList.toEntity(), todo.toEntity());

  Future<void> updateTodo(TodoList todoList, Todo todo) =>
      _todoRepository.updateTodo(todoList.toEntity(), todo.toEntity());

  Future<void> deleteTodos(TodoList todoList, List<Todo> todos) =>
      _todoRepository.deleteTodos(
          todoList.toEntity(), todos.map((todo) => todo.toEntity()).toList());

  Stream<List<TodoListEntity>> todoLists() => _todoRepository.todoLists();
}
