class TaskServiceException implements Exception {
  final String message;
  TaskServiceException(this.message);

  @override
  String toString() => message;
}
