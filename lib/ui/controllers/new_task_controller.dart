import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class NewTaskController extends GetxController {
  bool _newTaskInProgress = false;
  bool get getNewTaskInProgress => _newTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get getTaskListModel => _taskListModel;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;
    _newTaskInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTasks);

    _newTaskInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
