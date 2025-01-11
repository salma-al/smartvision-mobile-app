part of 'reports_cubit.dart';

@immutable
sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}

final class DateChanged extends ReportsState {}
final class ChangeRequestType extends ReportsState {}
final class ReportScrolled extends ReportsState {}

final class ReportLoading extends ReportsState {}
final class ReportLoaded extends ReportsState {}
final class ReportError extends ReportsState {}
