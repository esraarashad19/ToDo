import 'package:flutter/material.dart';
import 'package:my_todo_app/layout/cubit/cubit.dart';

class BuildTask extends StatelessWidget {
  final buildedTask;
  final taskType;
  BuildTask({@required this.buildedTask, @required this.taskType});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TodoCubit.get(context).openUpdateBottomSheet(buildedTask);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          top: 8,
        ),
        child: Container(
          height: 100,
          child: Card(
            elevation: 2,
            child: Row(
              children: [
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 35,
                  child: Text(
                    buildedTask['time'],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: Colors.teal,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      buildedTask['title'],
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      buildedTask['date'],
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                if (taskType == 'new')
                  IconButton(
                    icon: Icon(Icons.check_box_rounded),
                    onPressed: () {
                      TodoCubit.get(context).updateTask(
                        id: buildedTask['id'],
                        updatedStatus: 'done',
                      );
                      TodoCubit.get(context).newTasks.remove(buildedTask);
                    },
                  ),
                taskType != 'archive'
                    ? IconButton(
                        icon: Icon(Icons.archive),
                        onPressed: () {
                          TodoCubit.get(context).newTasks.remove(buildedTask);
                          TodoCubit.get(context).updateTask(
                              id: buildedTask['id'], updatedStatus: 'archive');
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          TodoCubit.get(context)
                              .deleteTask(id: buildedTask['id']);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
