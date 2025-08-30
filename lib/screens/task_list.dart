import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloctask/bloc_screen.dart';


class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager (BLoC)'),
        actions: [
          BlocBuilder<TaskBloc, TaskState>(
           // buildWhen: (p, n) => p.sort != n.sort,
            builder: (context, state) {
              return PopupMenuButton<TaskSort>(
                initialValue: state.sort,
                onSelected: (s) => context.read<TaskBloc>().add(TaskSorted(s)),
                itemBuilder: (_) => [
                  PopupMenuItem(value: TaskSort.titleAsce, child: const Text('Sort by Title')),
                  PopupMenuItem(value: TaskSort.isCom, child: const Text('Sort by Status')),
                ],
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (q) => context.read<TaskBloc>().add(TaskQueryChanged(q)),
              decoration: const InputDecoration(
                hintText: 'Search by title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<TaskBloc>().add(const TaskLoad()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (state.visible.isEmpty) return const Center(child: Text('No tasks'));
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(0,12,0,0),
            itemCount: state.visible.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final t = state.visible[i];
              return SizedBox(
                height: 150,
                width: 150,
                child: Card(
                  color: Colors.black38,
                  child: ListTile(
                    title: Container(
                      height: 50,

                      decoration: BoxDecoration(
                        color: Colors.white38,
                            borderRadius: BorderRadius.circular(12)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(

                                child: Text(t.title.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  t.isCompleted ? 'Completed' : 'UnCompleted',style: TextStyle(color: t.isCompleted?Colors.green:Colors.red,fontSize:10 ,fontWeight: FontWeight.bold),

                                ),
                              ),
                            ],
                          )),
                        )),
                    subtitle: Container(
                      height: 80,
                        width: 80,
                        child: Center(child: Text(t.description==''?'Description':t.description,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white),))),

                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }
}
