import 'package:tasks_flutter_v2/model/uuid.dart';

class TodoListEntity {
  final String id;
  final String title;
  int countTodos;
  final int position;

  TodoListEntity({String id, this.title, this.countTodos, this.position})
      : this.id = id ?? Uuid().generateV4();

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ countTodos.hashCode ^ position.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoListEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          countTodos == other.countTodos &&
          position == other.position;

  Map<String, Object> toJson() {
    return {"title": title, "countTodos": countTodos, "position": position};
  }

  @override
  String toString() {
    return 'TodoListEntity{id: $id, title: $title, todos: $countTodos, position: $position}';
  }

  static TodoListEntity fromJson(Map<String, Object> json) {
    return TodoListEntity(
      id: json["id"] as String,
      title: json["title"] as String,
      countTodos: json["countTodos"] as int,
      position: json["position"] as int,
    );
  }
}
