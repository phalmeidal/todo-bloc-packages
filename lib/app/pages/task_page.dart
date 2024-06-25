import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/blocs/task_bloc.dart';
import '../data/blocs/task_event.dart';
import '../data/blocs/task_state.dart';
import '../data/models/task_model.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final TaskBloc _taskBloc;

  @override
  void initState() {
    super.initState();
    _taskBloc = TaskBloc();
    _taskBloc.add(GetTasks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
          bloc: _taskBloc,
          builder: (context, state) {
            if (state is TaskLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TaskLoadedState) {
              final list = state.tasks;
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Center(
                        child: Text(
                          list[index].title[0],
                        ),
                      ),
                    ),
                    title: Text(list[index].title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _taskBloc.add(
                          DeleteTasks(task: list[index]),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _taskBloc.add(
            PostTasks(
              task: TaskModel(
                title: 'Nova tarefa',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _taskBloc.close();
    super.dispose();
  }
}
