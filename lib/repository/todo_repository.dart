import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasks_flutter_v2/model/todo_entity.dart';
import 'package:tasks_flutter_v2/model/todo_list_entity.dart';

abstract class TodoRepository {
  Future<void> addTodoList(TodoListEntity todoList);

  Future<void> updateTodoList(TodoListEntity todoList);

  Future<void> deleteTodoLists(List<TodoListEntity> todoLists);

  Future<void> addTodo(TodoListEntity todoList, TodoEntity todo);

  Future<void> updateTodo(TodoListEntity todoList, TodoEntity todo);

  Future<void> deleteTodos(TodoListEntity todoList, List<TodoEntity> idList);

  Stream<List<TodoListEntity>> todoLists();
}

class FirestoreTodoRepository implements TodoRepository {
  static const String tasklistsPath = 'tasklists';

  final Firestore firestore;

  const FirestoreTodoRepository(this.firestore);

  @override
  Future<void> addTodoList(TodoListEntity todoList) {
    return firestore
        .collection(tasklistsPath)
        .document(todoList.id)
        .setData(todoList.toJson());
  }

  @override
  Future<void> updateTodoList(TodoListEntity todoList) {
    return firestore
        .collection(tasklistsPath)
        .document(todoList.id)
        .updateData(todoList.toJson());
  }

  @override
  Future<void> deleteTodoLists(List<TodoListEntity> todoLists) async {}

  @override
  Future<void> addTodo(TodoListEntity todoList, final TodoEntity todo) {
    todoList.todos.add(todo);
    return updateTodoList(todoList);
  }

  @override
  Future<void> updateTodo(TodoListEntity todoList, final TodoEntity todo) {
    int index = todoList.todos.indexOf(todo);
    todoList.todos[index] = todo;
    return updateTodoList(todoList);
  }

  @override
  Future<void> deleteTodos(
      TodoListEntity todoList, final List<TodoEntity> todos) {
    todos.forEach((todo) => todoList.todos.remove(todo));
    return updateTodoList(todoList);
  }

  @override
  Stream<List<TodoListEntity>> todoLists() {
    return firestore.collection(tasklistsPath).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return TodoListEntity(
            id: doc.documentID,
            title: doc['title'] ?? '',
            todos: List<TodoEntity>.from(doc['todos'].map((i) {
              return TodoEntity.fromJson(i);
            })));
      }).toList();
    });
  }
}
