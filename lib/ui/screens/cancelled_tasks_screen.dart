import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/instance_manager.dart';
import 'package:task_manager/ui/controllers/cancelled_task_controller.dart';

import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  final CancelledTaskController _cancelledTaskController =
      Get.find<CancelledTaskController>();

  @override
  void initState() {
    super.initState();
    _cancelledTaskController.getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: GetBuilder<CancelledTaskController>(
                builder: (cancelledTaskController) {
                  return Visibility(
                    visible:
                        cancelledTaskController.getCancelledTaskInProgress ==
                            false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: RefreshIndicator(
                      onRefresh: cancelledTaskController.getCancelledTaskList,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: cancelledTaskController
                                .getTaskListModel.taskList![index],
                            onChangeStatus: () {
                              cancelledTaskController.getCancelledTaskList();
                            },
                            onDelete: () {
                              cancelledTaskController.getCancelledTaskList();
                            },
                            clipColor: Colors.red,
                            showProgress: (inProgress) {},
                          );
                        },
                        itemCount: cancelledTaskController
                            .getTaskListModel.taskList?.length,
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
