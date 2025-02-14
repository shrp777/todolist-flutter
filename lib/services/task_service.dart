import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/services/task_service_exception.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

final options = BaseOptions(baseUrl: dotenv.env['API']!);
final Dio api = Dio(options);

class TaskService {
  static Future<List<Task>> findAll() async {
    try {
      List<Task> tasks = [];
      final Response response = await api.get('/tasks');

      if (response.statusCode == 200 || response.statusCode == 304) {
        tasks = response.data["tasks"]
            .map<Task>((json) => Task.fromJSON(json))
            .toList();
      }

      return tasks;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw TaskServiceException("Can't find tasks (error with API)");
    }
  }

  static Future<Task> findOneById(String id) async {
    try {
      final Response response = await api.get("/tasks/$id");

      if (response.statusCode == 200 || response.statusCode == 304) {
        return Task.fromJSON(response.data["task"]);
      } else if (response.statusCode == 404) {
        throw TaskServiceException("Task $id does not exist");
      } else {
        throw TaskServiceException("Task while fetching data (error with API)");
      }
    } on TaskServiceException {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw TaskServiceException("Can't find task $id (error with API)");
    }
  }
}
