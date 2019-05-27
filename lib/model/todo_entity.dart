import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tasks_flutter_v2/model/uuid.dart';

class TodoEntity {
  final String id;
  final String title;
  final String note;
  final int position;
  final bool complete;
  final bool reminderSet;
  final DateTime reminder;

  TodoEntity(
      {String id,
      this.title,
      this.note,
      @required this.position,
      this.complete = false,
      this.reminderSet = false,
      this.reminder})
      : this.id = id ?? Uuid().generateV4();

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      note.hashCode ^
      position.hashCode ^
      complete.hashCode ^
      reminderSet.hashCode ^
      reminder.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          note == other.note &&
          position == other.position &&
          complete == other.complete &&
          reminderSet == other.reminderSet &&
          reminder == other.reminder;

  Map<String, Object> toJson() {
    return {
      "title": title,
      "note": note,
      "position": position,
      "complete": complete,
      "reminderSet": reminderSet,
      "reminder": reminder,
    };
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, title: $title, note: $note, position: $position, complete: $complete, reminderSet: $reminderSet, reminder: $reminder}';
  }

  static TodoEntity fromJson(Map<dynamic, dynamic> json) {
    return TodoEntity(
      id: json["id"] as String,
      title: json["title"] as String,
      note: json["note"] as String,
      position: json["position"] as int,
      complete: json["complete"] as bool,
      reminderSet: json["reminderSet"] as bool,
      reminder: (json["reminder"] as Timestamp)?.toDate(),
    );
  }
}
