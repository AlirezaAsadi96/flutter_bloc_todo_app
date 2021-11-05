import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/edit_todo_cubit.dart';
import 'package:todo_app/data/models/todo.dart';

class EditTodoScreen extends StatelessWidget {
  final Todo todo;
  EditTodoScreen({Key? key, required this.todo}) : super(key: key);
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = todo.title!;
    return BlocListener<EditTodoCubit, EditTodoState>(
      listener: (context, state) {
        if (state is TodoEdited) {
          Navigator.pop(context);
        } else if (state is EditTodoError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Todo"),
          actions: [
            IconButton(
              onPressed: () {
                BlocProvider.of<EditTodoCubit>(context).deleteTodo(todo);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Enter todo message",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            child: _updateButton(context),
            onTap: () {
              BlocProvider.of<EditTodoCubit>(context)
                  .updateTodo(todo, _controller.text);
            },
          ),
        ],
      ),
    );
  }

  Widget _updateButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: BlocBuilder<EditTodoCubit, EditTodoState>(
          builder: (context, state) {
            if (state is TodoEditing) {
              return const CircularProgressIndicator(
                color: Colors.black,
              );
            }
            return const Text(
              "Update Todo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
