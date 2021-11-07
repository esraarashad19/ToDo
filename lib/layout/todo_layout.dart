import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/layout/cubit/cubit.dart';
import 'package:my_todo_app/layout/cubit/states.dart';
import 'package:my_todo_app/layout/reusable_text_form_field.dart';
import 'package:my_todo_app/screens/archived_screen.dart';
import 'package:my_todo_app/screens/done_screen.dart';
import 'package:my_todo_app/screens/new_task_screen.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var titleController = TextEditingController();

  List<String> screensTitle = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {
        if (state is TodoInsertTaskState || state is TodoUpdateTaskDataState) {
          Navigator.pop(context);
          TodoCubit.get(context).resetBottomSheet(false);
          dateController.clear();
          titleController.clear();
          timeController.clear();
        }
        if (state is TodoOpenUpdateBottomSheet) {
          openBottomSheet(context: context, task: state.task);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              screensTitle[TodoCubit.get(context).bottomBarCurrentIndex],
            ),
          ),
          body: screens[TodoCubit.get(context).bottomBarCurrentIndex],
          floatingActionButton: FloatingActionButton(
            child: !TodoCubit.get(context).isBottomSheetOpen
                ? Icon(Icons.add)
                : Icon(Icons.close),
            onPressed: () {
              openBottomSheet(context: context);
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: TodoCubit.get(context).bottomBarCurrentIndex,
            onTap: (index) {
              TodoCubit.get(context).changeCurrentIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('Tasks'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check_circle_outline),
                title: Text('Done'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined),
                title: Text('Archived'),
              ),
            ],
          ),
        );
      },
    );
  }

  void openBottomSheet({context, task}) {
    if (!TodoCubit.get(context).isBottomSheetOpen) {
      if (task != null) {
        titleController..text = task['title'];
        timeController..text = task['time'];
        dateController..text = task['date'];
      }
      scaffoldKey.currentState
          .showBottomSheet(
            (context) {
              if (task != null)
                return addTaskScreen(context: context, task: task);
              else
                return addTaskScreen(context: context);
            },
          )
          .closed
          .then((value) {
            TodoCubit.get(context).resetBottomSheet(false);
            dateController.clear();
            titleController.clear();
            timeController.clear();
          });
      TodoCubit.get(context).resetBottomSheet(true);
    } else {
      Navigator.pop(context);
      TodoCubit.get(context).resetBottomSheet(false);
      dateController.clear();
      titleController.clear();
      timeController.clear();
    }
  }

//design for bottom sheet when press floatActionButton
  Widget addTaskScreen({context, task}) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ReUsableTextFormField(
                controllerText: titleController,
                hintText: 'task name',
                icon: Icons.title,
                keyboard: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              ReUsableTextFormField(
                keyboard: TextInputType.number,
                controllerText: timeController,
                hintText: 'task time',
                icon: Icons.alarm,
                onTapImplemnt: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((selectedTime) {
                    if (selectedTime != null) {
                      timeController.text = selectedTime.format(context);
                    } else
                      print('no time selected');
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              ReUsableTextFormField(
                keyboard: TextInputType.datetime,
                controllerText: dateController,
                hintText: 'task date',
                icon: Icons.calendar_today,
                onTapImplemnt: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2022),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      dateController.text =
                          DateFormat.yMMMd().format(selectedDate);
                    } else
                      print('no selected date please select date again');
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: FlatButton(
                  height: 50,
                  color: Colors.teal,
                  child: Text(
                    task == null ? 'Add Task' : 'Update Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print(titleController.text);
                      print(timeController.text);
                      print(dateController.text);
                      if (task == null) {
                        TodoCubit.get(context).insertTask(
                          time: timeController.text,
                          title: titleController.text,
                          date: dateController.text,
                        );
                      } else {
                        TodoCubit.get(context).updateTaskData(
                          time: timeController.text,
                          title: titleController.text,
                          date: dateController.text,
                          id: task['id'],
                        );
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
