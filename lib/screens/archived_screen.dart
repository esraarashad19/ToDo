import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/layout/cubit/cubit.dart';
import 'package:my_todo_app/layout/cubit/states.dart';
import 'package:my_todo_app/shared/components/build_task_design.dart';
import 'package:my_todo_app/shared/components/initial_empty_screen.dart';

class ArchivedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TodoCubit.get(context).archiveTasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) {
                  Map task = TodoCubit.get(context).archiveTasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    child: BuildTask(
                      buildedTask: task,
                      taskType: 'archive',
                    ),
                    onDismissed: (direction) {
                      TodoCubit.get(context).deleteTask(id: task['id']);
                    },
                    background: Container(
                      color: Colors.teal,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.grey,
                ),
                itemCount: TodoCubit.get(context).archiveTasks.length,
              )
            : InitialEmptyScreen();
      },
    );
  }

  // Widget buildTask(Map task, context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Row(
  //       children: [
  //         CircleAvatar(
  //           radius: 35,
  //           child: Text(task['time']),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               task['title'],
  //               style: TextStyle(fontSize: 18),
  //             ),
  //             SizedBox(
  //               height: 5,
  //             ),
  //             Text(
  //               task['date'],
  //               style: TextStyle(
  //                 color: Colors.grey,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ],
  //         ),
  //         Spacer(),
  //         IconButton(
  //             icon: Icon(
  //               Icons.delete,
  //               color: Colors.red,
  //             ),
  //             onPressed: () {
  //               TodoCubit.get(context).archiveTasks.remove(task);
  //             }),
  //       ],
  //     ),
  //   );
  // }
}
