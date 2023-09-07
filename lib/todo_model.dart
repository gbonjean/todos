class Todo {
  String id;
  String title;
  String content;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.content,
    this.completed = false,
  });

  Todo.fromJson(this.id, Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        completed = json['completed'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'completed': completed,
  };
}