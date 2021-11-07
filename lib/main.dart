import 'package:flutter/material.dart';
import 'file:///E:/course%20projects/my_todo_app/lib/layout/todo_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/layout/cubit/cubit.dart';
import 'package:my_todo_app/shared/todo_bloc_observe.dart';

void main() {
  Bloc.observer = TodoBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..openTodoDatabase(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
          accentColor: Colors.teal,
          backgroundColor: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
        home: TodoScreen(),
      ),
    );
  }
}
