part of 'announcement_cubit.dart';

@immutable
sealed class AnnouncementState {}

final class AnnouncementInitial extends AnnouncementState {}

final class AnnouncementLoading extends AnnouncementState {}
final class AnnouncementLoaded extends AnnouncementState {}
final class AnnouncementError extends AnnouncementState {}
