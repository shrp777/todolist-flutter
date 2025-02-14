import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/services/task_service.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const TodolistApp());
}

class TodolistApp extends StatelessWidget {
  const TodolistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<List<Task>>(
            future: TaskService.findAll(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
              if (snapshot.hasError) {
                return Text("Error while fetching data from API");
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Task currentTask = snapshot.data![index];

                      return ListTile(
                        title: Text(currentTask.content),
                        subtitle: Text(currentTask.status.name),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
