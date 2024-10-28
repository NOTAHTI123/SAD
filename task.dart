import 'dart:convert';
import 'dart:io';

class Task {
  String title;
  String description;
  bool isCompleted;

  @override
  String toString() {
    return 'Title: $title, Description: $description, Completed: $isCompleted';
  }

  Task(
      {required this.title,
      required this.description,
      this.isCompleted = false});
}

class TaskManager {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
  }

  void updateTask(int index, Task task) {
    if (index >= 0 && index < tasks.length) {
      tasks[index] = task;
    } else {
      print('Invalid index');
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
    } else {
      print('Invalid index');
    }
  }

  List<Task> getTasks() {
    return tasks;
  }

  List<Task> getCompletedTasks() {
    return tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> getIncompleteTasks() {
    return tasks.where((task) => !task.isCompleted).toList();
  }

  List<Task> getTaskByTitle(String title) {
    return tasks.where((task) => task.title == title).toList();
  }

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    } else {
      print('Invalid index');
    }
  }

  void saveTasksToFile(String filePath) {
    final file = File(filePath);
    final jsonList = tasks
        .map((task) => {
              'title': task.title,
              'description': task.description,
              'isCompleted': task.isCompleted
            })
        .toList();
    file.writeAsStringSync(jsonEncode(jsonList));
  }

  void loadTasksFromFile(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      final jsonList = jsonDecode(file.readAsStringSync()) as List;
      tasks = jsonList
          .map((json) => Task(
              title: json['title'],
              description: json['description'],
              isCompleted: json['isCompleted']))
          .toList();
    }
  }
}

void main() {
  TaskManager taskManager = TaskManager();

  while (true) {
    print('Task Manager:');
    print('1. Add a new task');
    print('2. Update a task');
    print('3. Delete a task');
    print('4. List all tasks');
    print('5. List completed tasks');
    print('6. List incomplete tasks');
    print('7. Toggle task completion status');
    print('8. Get task by title');
    print('9. Exit');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        print('Enter title:');
        final title = stdin.readLineSync() ?? '';
        print('Enter description:');
        final description = stdin.readLineSync() ?? '';
        taskManager.addTask(Task(title: title, description: description));
        print('Task added!');
        break;

      case '2':
        print('Enter task index to update:');
        final index = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
        if (index >= 0 && index < taskManager.getTasks().length) {
          print('Enter new title:');
          final title = stdin.readLineSync() ?? '';
          print('Enter new description:');
          final description = stdin.readLineSync() ?? '';
          taskManager.updateTask(
              index, Task(title: title, description: description));
          print('Task updated!');
        } else {
          print('Invalid index');
        }
        break;

      case '3':
        print('Enter task index to delete:');
        final index = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
        taskManager.deleteTask(index);
        print('Task deleted!');
        break;

      case '4':
        print('All Tasks:');
        taskManager.getTasks().asMap().forEach((index, task) {
          print(task.toString());
        });
        break;

      case '5':
        print('Completed Tasks:');
        taskManager.getCompletedTasks().forEach((task) {
          print(task.toString());
        });
        break;

      case '6':
        print('Incomplete Tasks:');
        taskManager.getIncompleteTasks().forEach((task) {
          print(task.toString());
        });
        break;

      case '7':
        print('Enter task index to toggle completion status:');
        final index = int.tryParse(stdin.readLineSync() ?? '') ?? -1;
        taskManager.toggleTaskCompletion(index);
        print('Task status toggled!');
        break;

      case '8':
        print('Enter task title to search:');
        final title = stdin.readLineSync() ?? '';
        taskManager.getTaskByTitle(title).forEach((task) {
          print(task.toString());
        });
        break;

      case '9':
        print('Exiting...');
        return;

      default:
        print('Invalid option, please try again.');
        break;
    }
  }
}
