part of 'meetings_cubit.dart';

@immutable
abstract class MeetingsState {}

class MeetingsInitial extends MeetingsState {}

class MeetingsLoading extends MeetingsState {}

class MeetingsLoaded extends MeetingsState {}

class MeetingSelected extends MeetingsState {}

class CalendarViewChanged extends MeetingsState {}

class DaySelected extends MeetingsState {}

class FocusedDayChanged extends MeetingsState {}