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
  Stream<List<TodoEntity>> todosByList(UserEntity user, String listId);
  Stream<TodoEntity> todo(UserEntity user, String id);
}

class FirestoreTodoRepository implements TodoRepository {
  static const String usersPath = 'users';
  static const String tasklistsPath = 'tasklists';
  static const String todosPath = 'todos';

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
    todoList.countTodos++;
    updateTodoList(user, todoList);

    return firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(todoList.id)
        .collection(todosPath)
        .document(todo.id)
        .setData(todo.toJson());
  }

  @override
  Future<void> updateTodo(
      final UserEntity user, final TodoListEntity todoList, final TodoEntity todo) {
    return firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(todoList.id)
        .collection(todosPath)
        .document(todo.id)
        .updateData(todo.toJson());
  }

  @override
  Future<void> deleteTodos(UserEntity user, TodoListEntity todoList, final List<TodoEntity> todos) {
    todoList.countTodos++;
    updateTodoList(user, todoList);

    final CollectionReference todoRef = firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(todoList.id)
        .collection(todosPath);

    todos.forEach((todo) {
      return todoRef.document(todo.id).delete();
    });
  }

  @override
  Stream<List<TodoListEntity>> todoLists(UserEntity user) {
    final CollectionReference reference =
        firestore.collection(usersPath).document(user.id).collection(tasklistsPath);
    final Stream<QuerySnapshot> querySnapshot = reference.snapshots();

    return querySnapshot.map((snapshot) {
      List<TodoListEntity> todoLists = snapshot.documents.map((doc) {
        return TodoListEntity(
            id: doc.documentID,
            title: doc['title'] ?? '',
            countTodos: doc['countTodos'],
            position: doc['position']);
      }).toList();

      todoLists.sort((a, b) => a.position.compareTo(b.position));
      return todoLists;
    });
  }

  @override
  Stream<List<TodoEntity>> todosByList(UserEntity user, String listId) {
    final CollectionReference reference = firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(listId)
        .collection(todosPath);
    final Stream<QuerySnapshot> querySnapshot = reference.snapshots();

    return querySnapshot.map((snapshot) {
      List<TodoEntity> todos = snapshot.documents.map((doc) {
        return TodoEntity(
            id: doc.documentID,
            title: doc['title'] ?? '',
            note: doc['note'] ?? '',
            position: doc['position'],
            complete: doc['complete'],
            reminderSet: doc['reminderSet'],
            reminder: doc['reminder']);
      }).toList();

      todos.sort((a, b) => a.position.compareTo(b.position));
      return todos;
    });
  }

  @override
  Stream<TodoEntity> todo(UserEntity user, String id) {
    final Stream<DocumentSnapshot> querySnapshot = firestore
        .collection(usersPath)
        .document(user.id)
        .collection(tasklistsPath)
        .document(id)
        .snapshots();
    querySnapshot.map((querySnapshot) {
      return TodoEntity(
          id: querySnapshot.documentID,
          title: querySnapshot['title'] ?? '',
          note: querySnapshot['note'] ?? '',
          position: querySnapshot['position'],
          complete: querySnapshot['complete'],
          reminderSet: querySnapshot['reminderSet'],
          reminder: querySnapshot['reminder']);
    });
  }
}
