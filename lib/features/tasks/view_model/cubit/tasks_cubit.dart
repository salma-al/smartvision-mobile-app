// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/toast_widget.dart';
import '../../model/tasks_model.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksInitial());

  static TasksCubit get(context) => BlocProvider.of(context);

  bool loading = false;
  List<TaskModel> tasks = [], filteredTasks = [];
  List<ProjectModel> projects = [];
  String? fromDate, toDate, fromDateValue, toDateValue, selectedStatus, selectedProject;
  bool isFilterExpanded = false;

  // For task details
  TaskModel? selectedTask;

  void getProjects(BuildContext context) async {
    try {
      loading = true;
      emit(TasksLoading());
      
      // In a real app, you would fetch projects from an API
      // For now, we'll use dummy data
      await Future.delayed(const Duration(milliseconds: 800));
      _loadDummyProjects();
      
      loading = false;
      emit(ProjectsLoaded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to load projects', context);
      emit(ProjectsLoaded());
    }
  }

  void getTasks(BuildContext context, {String? projectId}) async {
    try {
      loading = true;
      emit(TasksLoading());
      
      // In a real app, you would fetch tasks from an API with filters
      // For now, we'll use dummy data
      await Future.delayed(const Duration(milliseconds: 800));
      _loadDummyTasks();
      
      // Apply filters if any
      // _applyFilters(projectId: projectId);
      
      loading = false;
      emit(TasksLoaded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to load tasks', context);
      emit(TasksLoaded());
    }
  }

  void updateTaskStatus(BuildContext context, TaskModel task, String newStatus) async {
    try {
      loading = true;
      emit(TasksLoading());
      
      // In a real app, you would update the task status via an API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Update the task status locally
      task.status = newStatus;
      selectedTask = task; // Update selected task if it's the current one
      
      ToastWidget().showToast('Task status updated to $newStatus', context);
      
      loading = false;
      emit(TaskStatusUpdated());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to update task status', context);
    }
  }

  void selectTask(TaskModel task) {
    selectedTask = task;
    emit(TasksLoaded());
  }

  void toggleFilter() {
    isFilterExpanded = !isFilterExpanded;
    emit(TasksFilterToggled());
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (pickedDate != null) {
      if (isFromDate) {
        fromDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
        fromDateValue = fromDate;
      } else {
        toDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
        toDateValue = toDate;
      }
      emit(TasksDateChanged());
    }
  }

  void changeStatus(String? status) {
    selectedStatus = status;
    emit(TasksStatusChanged());
  }

  void changeProject(String? project) {
    selectedProject = project;
    emit(TasksProjectChanged());
  }

  void applyFilters(BuildContext context) {
    _applyFilters();
    toggleFilter();
  }

  void _applyFilters({String? projectId}) {
    filteredTasks = List.from(tasks);
    
    // Filter by project if specified
    if (projectId != null) {
      filteredTasks = filteredTasks.where((task) => task.projectName == projectId).toList();
      return;
    }
    
    // Filter by selected project
    if (selectedProject != null && selectedProject != 'All') {
      filteredTasks = filteredTasks.where((task) => task.projectName == selectedProject).toList();
    }
    
    // Filter by status
    if (selectedStatus != null && selectedStatus != 'All') {
      filteredTasks = filteredTasks.where((task) => task.status == selectedStatus).toList();
    }
    
    // Filter by date range
    if (fromDateValue != null && toDateValue != null) {
      // In a real app, you would implement proper date filtering
      // This is a simplified version
      filteredTasks = filteredTasks.where((task) {
        return task.date.compareTo(fromDateValue!) >= 0 && 
               (task.dueDate == null || task.dueDate!.compareTo(toDateValue!) <= 0);
      }).toList();
    }
    
    emit(TasksFiltered());
  }

  void _loadDummyProjects() {
    projects = [
      ProjectModel(
        id: 'P001',
        name: 'Mobile App Development',
        description: 'Develop a new mobile application for client',
        startDate: '2023-06-01',
        endDate: '2023-12-31',
        status: 'Active',
        tasksCount: 8,
      ),
      ProjectModel(
        id: 'P002',
        name: 'Website Redesign',
        description: 'Redesign company website with modern UI',
        startDate: '2023-07-15',
        status: 'Active',
        tasksCount: 5,
      ),
      ProjectModel(
        id: 'P003',
        name: 'Database Migration',
        description: 'Migrate legacy database to new cloud system',
        startDate: '2023-05-10',
        endDate: '2023-08-30',
        status: 'Completed',
        tasksCount: 6,
      ),
      ProjectModel(
        id: 'P004',
        name: 'API Integration',
        description: 'Integrate third-party APIs into the system',
        startDate: '2023-08-01',
        status: 'On Hold',
        tasksCount: 4,
      ),
    ];
  }

  void _loadDummyTasks() {
    tasks = [
      TaskModel(
        id: 'T001',
        title: 'Design User Interface',
        description: 'Create wireframes and mockups for the mobile app',
        projectName: 'Mobile App Development',
        date: '2023-06-05',
        dueDate: '2023-06-15',
        status: 'Completed',
        assignedBy: 'John Manager',
      ),
      TaskModel(
        id: 'T002',
        title: 'Implement Authentication',
        description: 'Develop login and registration functionality',
        projectName: 'Mobile App Development',
        date: '2023-06-16',
        dueDate: '2023-06-30',
        status: 'In Progress',
        assignedBy: 'John Manager',
      ),
      TaskModel(
        id: 'T003',
        title: 'Database Schema Design',
        description: 'Design the database schema for the new system',
        projectName: 'Database Migration',
        date: '2023-05-12',
        dueDate: '2023-05-20',
        status: 'Completed',
        assignedBy: 'Sarah Lead',
      ),
      TaskModel(
        id: 'T004',
        title: 'Homepage Redesign',
        description: 'Redesign the homepage with new branding',
        projectName: 'Website Redesign',
        date: '2023-07-20',
        dueDate: '2023-08-05',
        status: 'Pending',
        assignedBy: 'Mike Director',
      ),
      TaskModel(
        id: 'T005',
        title: 'Payment Gateway Integration',
        description: 'Integrate Stripe payment gateway',
        projectName: 'API Integration',
        date: '2023-08-10',
        dueDate: '2023-08-25',
        status: 'On Hold',
        assignedBy: 'Lisa Tech',
      ),
      TaskModel(
        id: 'T006',
        title: 'Testing and QA',
        description: 'Perform comprehensive testing of the mobile app',
        projectName: 'Mobile App Development',
        date: '2023-07-01',
        dueDate: '2023-07-15',
        status: 'In Progress',
        assignedBy: 'John Manager',
      ),
    ];
    
    filteredTasks = List.from(tasks);
  }
}
