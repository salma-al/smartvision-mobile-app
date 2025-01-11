part of 'attendance_cubit.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class DaysGenerated extends AttendanceState {}
final class DayChanged extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}
final class AttendanceLoaded extends AttendanceState {}
final class AttendanceError extends AttendanceState {}
