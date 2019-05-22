import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_flutter_v2/model/todo_entity.dart';
import 'package:tasks_flutter_v2/model/todo_list_entity.dart';
import 'package:tasks_flutter_v2/model/user_entity.dart';

abstract class TodoRepository {
  Future<void> addTodoList(UserEntity user, TodoListEntity todoList);

  Future<void> updateTodoList(UserEntity user, TodoListEntity todoList);

  Future<void> deleteTodoLists(UserEntity user, List<TodoListEntity> todoLists);

  Future<void> addTodo(UserEntity user, TodoListEntity todoList, TodoEntity todo);

  Future<void> updateTodo(UserEntity user, TodoListEntity todoList, TodoEntity todo);

  Future<void> deleteTodos(UserEntity user, TodoListEntity todoList, List<TodoEntity> idList);

  Stream<List<TodoListEntity>> todoLists(UserEntity user);
}

class FirestoreTodoRepository implements TodoRepository {
  static const String usersPath = 'users';
  static const String tasklistsPath = 'tasklists';

  final Firestore firestore;

  const FirestoreTodoRepository(this.firestore);

  @override
  Future<void> addTodoList(UserEntity user, TodoListEntity todoList) {
    return firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(todoList.id)
        .setData(todoList.toJson());
  }

  @override
  Future<void> updateTodoList(UserEntity user, TodoListEntity todoList) {
    return firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(todoList.id)
        .updateData(todoList.toJson());
  }

  @override
  Future<void> deleteTodoLists(UserEntity user, List<TodoListEntity> todoLists) async {}

  @override
  Future<void> addTodo(UserEntity user, TodoListEntity todoList, final TodoEntity todo) {
    todoList.todos.add(todo);
    return updateTodoList(user, todoList);
  }

  @override
  Future<void> updateTodo(UserEntity user, TodoListEntity todoList, final TodoEntity todo) {
    int index = todoList.todos.indexOf(todo);
    todoList.todos[index] = todo;
    return updateTodoList(user, todoList);
  }

  @override
  Future<void> deleteTodos(UserEntity user, TodoListEntity todoList, final List<TodoEntity> todos) {
    todos.forEach((todo) => todoList.todos.remove(todo));
    return updateTodoList(user, todoList);
  }

  @override
  Stream<List<TodoListEntity>> todoLists(UserEntity user) {
    final Stream<QuerySnapshot> querySnapshot =
        firestore.collection(usersPath).document(user.id).collection(tasklistsPath).snapshots();
    return querySnapshot.map((snapshot) {
      List<TodoListEntity> todoLists = snapshot.documents.map((doc) {
        return TodoListEntity(
            id: doc.documentID,
            title: doc['title'] ?? '',
            todos: List<TodoEntity>.from(doc['todos'].map((i) {
              return TodoEntity.fromJson(i);
            })),
            position: doc['position']);
      }).toList();
      todoLists.sort((a, b) => a.position.compareTo(b.position));
      return todoLists;
    });
  }
}
