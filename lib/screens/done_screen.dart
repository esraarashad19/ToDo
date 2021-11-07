import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/layout/cubit/cubit.dart';
import 'package:my_todo_app/layout/cubit/states.dart';
import 'package:my_todo_app/shared/components/build_task_design.dart';
import 'package:my_todo_app/shared/components/initial_empty_screen.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return TodoCubit.get(context).doneTasks.length > 0
            ? ListView.separated(
                itemBuilder: (context, index) {
                  Map task = TodoCubit.get(context).doneTasks[index];
                  return Dismissible(
                    key: UniqueKey(),
                    child: BuildTask(
                      buildedTask: task,
                      taskType: 'done',
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
                itemCount: TodoCubit.get(context).doneTasks.length,
              )
            : InitialEmptyScreen();
      },
    );
  }

  // Widget buildTask(Map task, context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
  //     child: Container(
  //       height: 100,
  //       child: Card(
  //         elevation: 2,
  //         child: Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 35,
  //               child: Text(task['time']),
  //             ),
  //             SizedBox(
  //               width: 10,
  //             ),
  //             Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   task['title'],
  //                   style: TextStyle(fontSize: 18),
  //                 ),
  //                 SizedBox(
  //                   height: 5,
  //                 ),
  //                 Text(
  //                   task['date'],
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 16,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Spacer(),
  //             IconButton(
  //               icon: Icon(Icons.archive),
  //               onPressed: () {
  //                 TodoCubit.get(context).doneTasks.remove(task);
  //                 TodoCubit.get(context)
  //                     .updateTask(id: task['id'], updatedStatus: 'archive');
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
