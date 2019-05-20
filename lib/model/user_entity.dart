import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String id;
  final String displayName;
  final String photoUrl;

  UserEntity({this.id, this.displayName, this.photoUrl});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ photoUrl.hashCode;

  @override
  String toString() {
    return 'UserEntity{id: $id, displayName: $displayName, photoUrl: $photoUrl}';
  }

  static UserEntity fromFirebaseUser(FirebaseUser firebaseUser) {
    return UserEntity(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }
}
