class Todo {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  Todo.fromJson(Map json)
      : userId = int.parse(json["userId"]!.toString()),
        id = json["id"]!,
        title = json["title"]!,
        completed = json["completed"]!.toString() == "false" ? false : true;
}
