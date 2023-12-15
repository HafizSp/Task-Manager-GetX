import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class CompletedTaskController extends GetxController {
  bool _completedTaskInProgress = false;
  bool get getCompletedTaskInProgress => _completedTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get getTaskListModel => _taskListModel;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;
    _completedTaskInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCompletedTask);
    _completedTaskInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
