import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_model.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class ProgressTaskController extends GetxController {
  bool _progressTaskInProgress = false;
  bool get getProgressTaskInProgress => _progressTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get getTaskListModel => _taskListModel;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _progressTaskInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTasks);
    _progressTaskInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
