class TodoRemote {
  const TodoRemote({
    required this.userId,
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  final int userId;
  final int id;
  final String title;
  final bool isCompleted;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory TodoRemote.fromMap(Map<String, dynamic> map) {
    return TodoRemote(
      userId: map['userId'] as int,
      id: map['id'] as int,
      title: map['title'] as String,
      isCompleted: map['completed'] as bool,
    );
  }

  @override
  String toString() {
    return 'TodoRemote(userId: $userId, id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
