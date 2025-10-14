import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../model/tasks_model.dart';
import '../view_model/cubit/tasks_cubit.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()..selectTask(task),
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          var cubit = TasksCubit.get(context);
          final currentTask = cubit.selectedTask ?? task;
          
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Task Details', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              actions: [
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Title and Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    currentTask.title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(currentTask.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentTask.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Project: ${currentTask.projectName}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.darkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Task Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentTask.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 18, color: AppColors.darkColor),
                                const SizedBox(width: 8),
                                Text(
                                  'Created: ${currentTask.date}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                            if (currentTask.dueDate != null) ...[  
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.event, size: 18, color: AppColors.darkColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Due: ${currentTask.dueDate}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (currentTask.assignedBy != null) ...[  
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.person, size: 18, color: AppColors.darkColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Assigned by: ${currentTask.assignedBy}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Update Status Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusButton(context, cubit, currentTask, 'Pending'),
                                _buildStatusButton(context, cubit, currentTask, 'In Progress'),
                                _buildStatusButton(context, cubit, currentTask, 'Completed'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatusButton(context, cubit, currentTask, 'On Hold'),
                                _buildStatusButton(context, cubit, currentTask, 'Cancelled'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Comments/Notes Section (placeholder for future implementation)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.darkColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Add Comment',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Comments feature coming soon')),
                                );
                              },
                              color: AppColors.mainColor.withValues(alpha: 0.8),
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (cubit.loading) const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, TasksCubit cubit, TaskModel task, String status) {
    bool isCurrentStatus = task.status == status;
    
    return GestureDetector(
      onTap: isCurrentStatus ? null : () => cubit.updateTaskStatus(context, task, status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCurrentStatus ? _getStatusColor(status) : Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isCurrentStatus ? Colors.white : AppColors.darkColor,
            fontWeight: isCurrentStatus ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'in progress':
        return AppColors.mainColor;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'on hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}