import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../components/task_component.dart';
import '../view_model/cubit/tasks_cubit.dart';
import 'task_details_screen.dart';

class TasksScreen extends StatelessWidget {
  final String? projectId;
  final String? projectName;

  const TasksScreen({super.key, this.projectId, this.projectName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()..getTasks(context, projectId: projectId),
      child: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          var cubit = TasksCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                projectName != null ? 'Tasks: $projectName' : 'All Tasks',
                style: TextStyle(color: AppColors.mainColor),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(Icons.filter_list, color: AppColors.mainColor),
                  onPressed: () => cubit.toggleFilter(),
                ),
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                Column(
                  children: [
                    // Collapsible Filter Section
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: cubit.isFilterExpanded ? null : 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                              'Date Range',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: PrimaryButton(
                                    text: cubit.fromDate != null ? cubit.fromDate! : 'From Date',
                                    onTap: () => cubit.selectDate(context, true),
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    textColor: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: PrimaryButton(
                                    text: cubit.toDate != null ? cubit.toDate! : 'To Date',
                                    onTap: () => cubit.selectDate(context, false),
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    textColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomDropdownFormField(
                              hintText: 'Task Status',
                              value: cubit.selectedStatus,
                              items: const [
                                DropdownMenuItem(value: 'All', child: Text('All')),
                                DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                                DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                                DropdownMenuItem(value: 'On Hold', child: Text('On Hold')),
                                DropdownMenuItem(value: 'Cancelled', child: Text('Cancelled')),
                              ],
                              onChanged: (value) => cubit.changeStatus(value),
                            ),
                            if (projectId == null) ...[  
                              const SizedBox(height: 16),
                              Text(
                                'Project',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.darkColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FutureBuilder(
                                future: Future.delayed(Duration.zero, () => cubit.projects),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || cubit.projects.isEmpty) {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                  
                                  List<DropdownMenuItem<String>> projectItems = [
                                    const DropdownMenuItem(value: 'All', child: Text('All')),
                                  ];
                                  
                                  for (var project in cubit.projects) {
                                    projectItems.add(DropdownMenuItem(
                                      value: project.name,
                                      child: Text(project.name),
                                    ));
                                  }
                                  
                                  return CustomDropdownFormField(
                                    hintText: 'Select Project',
                                    value: cubit.selectedProject,
                                    items: projectItems,
                                    onChanged: (value) => cubit.changeProject(value),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 16),
                            Center(
                              child: PrimaryButton(
                                text: 'Apply Filters',
                                onTap: () => cubit.applyFilters(context),
                                color: AppColors.mainColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Tasks List
                    Expanded(
                      child: cubit.filteredTasks.isEmpty && !cubit.loading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: AppColors.mainColor.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No tasks found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async => cubit.getTasks(context, projectId: projectId),
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 16, bottom: 16),
                              itemCount: cubit.filteredTasks.length,
                              itemBuilder: (context, index) {
                                final task = cubit.filteredTasks[index];
                                return TaskComponent(
                                  task: task,
                                  onTap: () {
                                    cubit.selectTask(task);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskDetailsScreen(task: task),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                    ),
                  ],
                ),
                if (cubit.loading) const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}