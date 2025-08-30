import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/respository/repository.dart';
import 'package:task_manager/screens/task_add.dart';
import 'package:task_manager/screens/task_list.dart';
import 'package:task_manager/services/services.dart';

import 'bloctask/bloc_screen.dart';

void main() {
  final service = TodoService();
  final repo = TodoRepository(service);

  runApp(
      RepositoryProvider.value(value: repo,child:  BlocProvider(
        create: (_) => TaskBloc(repo)..add(const TaskLoad()),
        child: const MyApp(),
      ),));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',

      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const TaskListPage(),
        '/add': (_) => const AddTaskPage(),
      },
    );
  }
}



