import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/add_todo_cubit.dart';

class AddTodoScreen extends StatelessWidget {
  AddTodoScreen({Key? key}) : super(key: key);

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Todo"),
        ),
        body: BlocListener<AddTodoCubit, AddTodoState>(
          listener: (context, state) {
            if (state is TodoAdded) {
              Navigator.pop(context);
            } else if (state is AddTodoError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            child: _body(context),
          ),
        ));
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        TextField(
          autofocus: true,
          controller: _controller,
          decoration: const InputDecoration(hintText: "Enter todo message..."),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: _addBtn(context),
          onTap: () {
            final message = _controller.text;
            BlocProvider.of<AddTodoCubit>(context).addTodo(message);
          },
        ),
      ],
    );
  }
}

Widget _addBtn(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).primaryColor,
    ),
    child: Center(
      child: BlocBuilder<AddTodoCubit, AddTodoState>(
        builder: (context, state) {
          if (state is AddingTodo) {
            return const CircularProgressIndicator(
              color: Colors.black,
            );
          }
          return const Text(
            "Add Todo",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        },
      ),
    ),
  );
}
