import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';

import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class InProgressTasksScreen extends StatefulWidget {
  const InProgressTasksScreen({super.key});

  @override
  State<InProgressTasksScreen> createState() => _InProgressTasksScreenState();
}

class _InProgressTasksScreenState extends State<InProgressTasksScreen> {
  final ProgressTaskController _progressTaskController =
      Get.find<ProgressTaskController>();

  @override
  void initState() {
    super.initState();
    _progressTaskController.getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: GetBuilder<ProgressTaskController>(
                builder: (progressTaskController) {
                  return Visibility(
                    visible: progressTaskController.getProgressTaskInProgress ==
                        false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () =>
                          progressTaskController.getProgressTaskList(),
                      child: ListView.builder(
                        itemBuilder: (context, index) => TaskItemCard(
                          task: progressTaskController
                              .getTaskListModel.taskList![index],
                          onChangeStatus: () {
                            progressTaskController.getProgressTaskList();
                          },
                          onDelete: () {
                            progressTaskController.getProgressTaskList();
                          },
                          clipColor: Colors.lightGreen,
                          showProgress: (inProgress) {},
                        ),
                        itemCount: progressTaskController
                                .getTaskListModel.taskList?.length ??
                            0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
