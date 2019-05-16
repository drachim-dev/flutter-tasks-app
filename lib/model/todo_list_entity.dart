import 'package:tasks_flutter_v2/model/todo_entity.dart';
import 'package:tasks_flutter_v2/model/uuid.dart';

class TodoListEntity {
  final String id;
  final String title;
  final List<TodoEntity> todos;

  TodoListEntity({String id, this.title, this.todos})
      : this.id = id ?? Uuid().generateV4();

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ todos.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          todos == other.todos;

  Map<String, Object> toJson() {
    return {
      "title": title,
      "todos": todos.map((entity) => entity.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'TodoListEntity{id: $id, title: $title, todos: $todos}';
  }

  static TodoListEntity fromJson(Map<String, Object> json) {
    return TodoListEntity(
      id: json["id"] as String,
      title: json["title"] as String,
      todos: json["todos"] as List<TodoEntity>,
    );
  }
}
