part of 'leaves_cubit.dart';

@immutable
sealed class LeavesState {}

final class LeavesInitial extends LeavesState {}

final class RequestChanged extends LeavesState {}
final class ReuestTimeChanged extends LeavesState {}
final class FilePicked extends LeavesState {}

final class LeavesLoadingState extends LeavesState {}
final class LeavesLoadedState extends LeavesState {}
final class LeavesErrorState extends LeavesState {}
