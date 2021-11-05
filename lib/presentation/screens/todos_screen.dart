import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/constants/strings.dart';
import 'package:todo_app/cubit/todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodoCubit>(context).fetchTodo();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Todos"),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, addTodoRoutes),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            if (state is! TodosLoaded) {
              return const Center(child: CupertinoActivityIndicator());
            }
            final todos = (state as TodosLoaded).todos;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: todos.map((todo) => _todo(todo, context)).toList(),
              ),
            );
          },
        ));
  }
}

Widget _todo(Todo todo, BuildContext context) {
  return InkWell(
    onTap: () =>
        Navigator.of(context).pushNamed(editTodoRoutes, arguments: todo),
    child: Dismissible(
      direction: DismissDirection.startToEnd,
      key: Key("${todo.id}"),
      child: _todoTitle(todo, context),
      confirmDismiss: (direction) async {
        context.read<TodoCubit>().changeCompletion(todo);
        return false;
      },
      background: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: todo.completed!
                  ? const Text(
                      "Uncompleted",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : const Text("Completed",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _todoTitle(Todo todo, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            todo.title.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _completionIndicator(todo),
      ],
    ),
  );
}

Widget _completionIndicator(Todo todo) {
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      border: Border.all(
        width: 4,
        color: todo.completed! ? Colors.green : Colors.red,
      ),
    ),
  );
}
