import 'package:flutter_test/flutter_test.dart';
import 'package:todo_bloc_packages/app/data/blocs/task_bloc.dart';
import 'package:todo_bloc_packages/app/data/blocs/task_event.dart';
import 'package:todo_bloc_packages/app/data/blocs/task_state.dart';
import 'package:todo_bloc_packages/app/data/models/task_model.dart';

void main() {
  group('TaskBloc Tests', () {
    late TaskBloc taskBloc;

    setUp(() {
      taskBloc = TaskBloc();
    });

    test('initial state should be TaskInitialState', () {
      expect(taskBloc.state, isA<TaskInitialState>());
    });

    test('state should be TaskLoadingState and then TaskLoadedState after GetTasks event', () async {
      final expectedResponse = [
        isA<TaskLoadingState>(),
        isA<TaskLoadedState>(),
      ];

      expectLater(
        taskBloc.stream,
        emitsInOrder(expectedResponse),
      );

      taskBloc.add(GetTasks());
    });

    test('TaskLoadedState should contain a list of tasks after GetTasks event', () async {
      taskBloc.add(GetTasks());

      await expectLater(
        taskBloc.stream,
        emitsThrough(isA<TaskLoadedState>()),
      );

      expect(taskBloc.state, isA<TaskLoadedState>());
      final state = taskBloc.state as TaskLoadedState;
      expect(state.tasks.isNotEmpty, true);
    });

    test('Adding a task should increase tasks list', () async {
      final initialTask = TaskModel(title: 'Initial Task');
      taskBloc.add(PostTasks(task: initialTask));

      await expectLater(
        taskBloc.stream,
        emitsThrough(isA<TaskLoadedState>()),
      );

      final state = taskBloc.state as TaskLoadedState;
      final initialCount = state.tasks.length;

      final newTask = TaskModel(title: 'New Task');
      taskBloc.add(PostTasks(task: newTask));

      await expectLater(
        taskBloc.stream,
        emitsThrough(isA<TaskLoadedState>()),
      );

      final newState = taskBloc.state as TaskLoadedState;
      expect(newState.tasks.length, greaterThan(initialCount));
    });

    test('Deleting a task should decrease tasks list', () async {
      final taskToDelete = TaskModel(title: 'Task to Delete');
      taskBloc.add(PostTasks(task: taskToDelete));

      await expectLater(
        taskBloc.stream,
        emitsThrough(isA<TaskLoadedState>()),
      );

      final stateBeforeDelete = taskBloc.state as TaskLoadedState;
      final countBeforeDelete = stateBeforeDelete.tasks.length;

      taskBloc.add(DeleteTasks(task: taskToDelete));

      await expectLater(
        taskBloc.stream,
        emitsThrough(isA<TaskLoadedState>()),
      );

      final stateAfterDelete = taskBloc.state as TaskLoadedState;
      expect(stateAfterDelete.tasks.length, lessThan(countBeforeDelete));
    });

    tearDown(() {
      taskBloc.close();
    });
  });
}
