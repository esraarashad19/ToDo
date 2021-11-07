import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/layout/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);
  int bottomBarCurrentIndex = 0;
  bool isBottomSheetOpen = false;
  Database database;

  //task lists
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  //change BottomBar current index to move between screens
  void changeCurrentIndex(int index) {
    bottomBarCurrentIndex = index;
    emit(TodoChangeBottomBarState());
  }

  // open/close BottomSheet
  void resetBottomSheet(bool isOpen) {
    isBottomSheetOpen = isOpen;
    emit(TodoChangeBottomSheetState());
  }

  // open and create database and fill 3 lists(newTasks,doneTasks,archiveTasks) with tasks
  void openTodoDatabase() {
    openDatabase(
      'todo_database',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'create table task(id integer primary key,title text,time text ,date text , status text)')
            .then((value) => print('table created'));
      },
      onOpen: (db) {
        print('database opened');
      },
    ).then((value) {
      emit(TodoOpenDatabaseState());
      database = value;
      getTasks(database);
    });
  }

  //get tasks from database
  void getTasks(database) {
    try {
      database.rawQuery('select * from task').then((value) {
        print(value);
        if (value != null) {
          newTasks = [];
          doneTasks = [];
          archiveTasks = [];
          value.forEach((element) {
            if (element['status'] == 'new')
              newTasks.add(element);
            else if (element['status'] == 'done')
              doneTasks.add(element);
            else if (element['status'] == 'archive') archiveTasks.add(element);
          });
        }
        emit(TodoGetTasksState());
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  //insert new task
  void insertTask({@required title, @required time, @required date}) {
    try {
      int id;
      database.transaction((txn) async {
        txn.rawInsert(
            'insert into task(title,time,date,status) values(?,?,?,?)',
            [title, time, date, "new"]).then((value) {
          emit(TodoInsertTaskState());
          getTasks(database);
          print('1 row has been inserted with id =$id');
        });
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  //delete task
  void deleteTask({@required id}) {
    try {
      database.rawDelete('DELETE FROM task WHERE id=$id ').then((value) {
        print('$value row has been deleted');
        getTasks(database);
        emit(TodoDeleteTaskState());
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  //update task
  void updateTask({@required id, @required updatedStatus}) {
    try {
      int effectedRow;
      database.transaction((txn) async {
        effectedRow = await txn.rawUpdate(
            'update task set status=? where id=?', [updatedStatus, id]);
      });
      print('$effectedRow row has been updated');
      getTasks(database);
      emit(TodoUpdateTaskState());
    } catch (exception) {
      print(exception.toString());
    }
  }

//update task data
  void updateTaskData({
    @required title,
    @required time,
    @required date,
    @required id,
  }) {
    try {
      int effectedRow;
      database.transaction((txn) async {
        effectedRow = await txn.rawUpdate(
            'update task set title=? , time=? ,date=? where id=?',
            [title, time, date, id]);
      });
      print('$effectedRow row has been updated');
      getTasks(database);
      emit(TodoUpdateTaskDataState());
    } catch (exception) {
      print(exception.toString());
    }
  }

  //open bottom sheet for updating task data
  void openUpdateBottomSheet(task) {
    emit(TodoOpenUpdateBottomSheet(task));
  }
}
