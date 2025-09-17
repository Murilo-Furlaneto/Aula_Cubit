import 'package:aula_cubit/cubits/todo_cubit.dart';
import 'package:aula_cubit/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.indigo),
        home: const HomePage(title: "Aula Cubit"),
      ),
    );
  }
}
