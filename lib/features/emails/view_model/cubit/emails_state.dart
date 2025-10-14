part of 'emails_cubit.dart';

@immutable
sealed class EmailState {}

final class EmailInitial extends EmailState {}

final class EmailLoading extends EmailState {}
final class EmailsLoaded extends EmailState {}

final class EmailFilterToggled extends EmailState {}
final class EmailDateRangeChanged extends EmailState {}
final class EmailTypeChanged extends EmailState {}
final class EmailStarredToggled extends EmailState {}
final class EmailReadToggled extends EmailState {}
final class EmailFiltered extends EmailState {}

final class EmailStarredUpdated extends EmailState {}
final class EmailReadUpdated extends EmailState {}
final class EmailDeleted extends EmailState {}
final class EmailSent extends EmailState {}
final class EmailDrafted extends EmailState {}
final class EmailForwarded extends EmailState {}
final class EmailReplied extends EmailState {}

final class AttachmentDownloaded extends EmailState {}
final class SignatureUpdated extends EmailState {}