part of 'attendance_cubit.dart';

@immutable
sealed class AttendanceState {}

final class AttendanceInitial extends AttendanceState {}

final class DaysGenerated extends AttendanceState {}
final class MonthChanged extends AttendanceState {}
final class TypeSelected extends AttendanceState {}

final class AttendanceLoading extends AttendanceState {}
final class AttendanceLoaded extends AttendanceState {}
final class AttendanceError extends AttendanceState {}
