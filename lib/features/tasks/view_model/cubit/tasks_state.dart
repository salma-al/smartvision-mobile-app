part of 'tasks_cubit.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {}

final class TasksLoading extends TasksState {}
final class TasksLoaded extends TasksState {}
final class ProjectsLoaded extends TasksState {}

final class TasksFilterToggled extends TasksState {}
final class TasksDateChanged extends TasksState {}
final class TasksStatusChanged extends TasksState {}
final class TasksProjectChanged extends TasksState {}
final class TasksFiltered extends TasksState {}

final class TaskStatusUpdated extends TasksState {}
