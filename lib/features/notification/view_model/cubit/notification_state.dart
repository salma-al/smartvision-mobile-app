part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}
final class NotificationLoaded extends NotificationState {}
final class NotificationError extends NotificationState {}
