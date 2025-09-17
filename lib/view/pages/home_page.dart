import 'package:aula_cubit/cubits/todo_cubit.dart';
import 'package:aula_cubit/cubits/todo_state.dart';
import 'package:aula_cubit/view/widgets/todo_lsit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  late final TodoCubit cubit;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TodoCubit>(context);
    cubit.stream.listen((state){
      if(state is ErrorTodoState){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message))
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,),
      body: Stack(
        children: [
          BlocBuilder(
            bloc: cubit,
            builder: (context, state) {
              if (state is InitialTodoState) {
                return Center(
                  child: Text("Nenhuma tarefa foi adicionada ainda"),
                );
              } else if (state is LoadingTodoState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LoadedTodoState) {
                return TodoLsitWidget(todos: state.todos, cubit: cubit,);
              } else {
                return TodoLsitWidget(todos: cubit.todos, cubit: cubit,);
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: const Offset(0, -5),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Digite um nome',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            )
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (_nameController.text.trim().isNotEmpty) {
                          cubit.addTodo(_nameController.text);
                          _nameController.clear();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
