abstract class TodoStates {}

class TodoInitialState extends TodoStates {}

// database changes
class TodoOpenDatabaseState extends TodoStates {}

class TodoGetTasksState extends TodoStates {}

class TodoInsertTaskState extends TodoStates {}

class TodoUpdateTaskState extends TodoStates {}

class TodoDeleteTaskState extends TodoStates {}

class TodoUpdateTaskDataState extends TodoStates {}

// todo layout states
class TodoChangeBottomBarState extends TodoStates {}

class TodoChangeBottomSheetState extends TodoStates {}

class TodoOpenUpdateBottomSheet extends TodoStates {
  final task;
  TodoOpenUpdateBottomSheet(this.task);
}
