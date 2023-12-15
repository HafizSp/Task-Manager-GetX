import 'package:get/get.dart';

import '../../data/models/task_count_summary_list_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';

class TaskCountSummaryController extends GetxController {
  bool _taskCountSummaryInProgress = false;
  bool get getTaskCountSummaryInProgress => _taskCountSummaryInProgress;

  TaskCountSummaryListModel _taskCountSummaryListModel =
      TaskCountSummaryListModel();

  TaskCountSummaryListModel get getTaskCountSummaryListModel =>
      _taskCountSummaryListModel;

  Future<bool> getTaskCountSummary() async {
    bool isSuccess = false;
    _taskCountSummaryInProgress = true;
    update();

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);

    _taskCountSummaryInProgress = false;

    if (response.isSuccess) {
      _taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
      isSuccess = true;
    }
    update();
    return isSuccess;
  }
}
