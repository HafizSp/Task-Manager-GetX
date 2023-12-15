import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class CancelledTaskController extends GetxController {
  bool _cancelledTaskInProgress = false;
  bool get getCancelledTaskInProgress => _cancelledTaskInProgress;
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get getTaskListModel => _taskListModel;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;
    _cancelledTaskInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCancelledTask);
    _cancelledTaskInProgress = false;

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
