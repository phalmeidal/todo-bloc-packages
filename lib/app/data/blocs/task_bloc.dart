import 'package:bloc/bloc.dart';

import '../models/task_model.dart';
import '../repositories/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final _repository = TaskRepository();

  TaskBloc() : super(TaskInitialState()) {
    on(_mapEventToState);
  }

  void _mapEventToState(TaskEvent event, Emitter emit) async {
    List<TaskModel> tasks = [];

    emit(TaskLoadingState());

    if (event is GetTasks) {
      tasks = await _repository.getTasks();
    } else if (event is PostTasks) {
      tasks = await _repository.postTask(task: event.task);
    } else if (event is DeleteTasks) {
      tasks = await _repository.deleteTask(task: event.task);
    }

    emit(TaskLoadedState(tasks: tasks));
  }
}
