import 'package:tasks_flutter_v2/model/todo_list_entity.dart';

class TodoList {
  final String id;
  String title;
  final int countTodos;
  int position;

  TodoList({this.id, this.title = '', this.countTodos = 0, this.position});

  TodoList copyWith({String id, String title}) {
    return TodoList(
      id: id ?? this.id,
      title: title ?? this.title,
      countTodos: countTodos ?? this.countTodos,
      position: position ?? this.position,
    );
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ countTodos.hashCode ^ position.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          countTodos == other.countTodos &&
          position == other.position;

  @override
  String toString() {
    return 'TodoList{id: $id, title: $title, countTodos: $countTodos, position: $position}';
  }

  TodoListEntity toEntity() {
    return TodoListEntity(id: id, title: title, countTodos: countTodos, position: position);
  }

  static TodoList fromEntity(TodoListEntity entity) {
    return TodoList(
        id: entity.id,
        title: entity.title,
        countTodos: entity.countTodos,
        position: entity.position);
  }
}
