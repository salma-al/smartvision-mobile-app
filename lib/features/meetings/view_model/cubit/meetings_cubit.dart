import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../model/meeting_model.dart';

part 'meetings_state.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  MeetingsCubit() : super(MeetingsInitial());

  static MeetingsCubit get(context) => BlocProvider.of(context);
  
  List<MeetingModel> meetings = [];
  MeetingModel? selectedMeeting;
  CalendarView currentView = CalendarView.month;
  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  void loadMeetings() {
    emit(MeetingsLoading());
    // In a real app, you would fetch meetings from an API
    // For now, we'll use dummy data
    meetings = _getDummyMeetings();
    emit(MeetingsLoaded());
  }

  void selectMeeting(MeetingModel meeting) {
    selectedMeeting = meeting;
    emit(MeetingSelected());
  }

  void changeCalendarView(CalendarView view) {
    currentView = view;
    emit(CalendarViewChanged());
  }

  void selectDay(DateTime day) {
    selectedDay = day;
    emit(DaySelected());
  }

  void updateFocusedDay(DateTime day) {
    focusedDay = day;
    emit(FocusedDayChanged());
  }

  List<MeetingModel> getMeetingsForDay(DateTime day) {
    return meetings.where((meeting) {
      return meeting.startTime.year == day.year &&
          meeting.startTime.month == day.month &&
          meeting.startTime.day == day.day;
    }).toList();
  }

  List<MeetingModel> _getDummyMeetings() {
    final now = DateTime.now();
    return [
      MeetingModel(
        id: '1',
        title: 'Team Standup',
        description: 'Daily team standup meeting',
        startTime: DateTime(now.year, now.month, now.day, 9, 0),
        endTime: DateTime(now.year, now.month, now.day, 9, 30),
        location: 'Conference Room A',
        participants: ['John', 'Sarah', 'Mike'],
      ),
      MeetingModel(
        id: '2',
        title: 'Project Review',
        description: 'Monthly project review with stakeholders',
        startTime: DateTime(now.year, now.month, now.day, 13, 0),
        endTime: DateTime(now.year, now.month, now.day, 14, 30),
        location: 'Main Hall',
        participants: ['CEO', 'CTO', 'Project Managers'],
      ),
      MeetingModel(
        id: '3',
        title: 'Client Meeting',
        description: 'Discussion about new requirements',
        startTime: DateTime(now.year, now.month, now.day + 1, 11, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        location: 'Virtual',
        participants: ['Client A', 'Sales Team'],
      ),
      MeetingModel(
        id: '4',
        title: 'All-day Conference',
        description: 'Annual industry conference',
        startTime: DateTime(now.year, now.month, now.day + 3, 0, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 23, 59),
        location: 'Convention Center',
        participants: ['All Employees'],
        isAllDay: true,
      ),
    ];
  }

  int getEndedMeetingsCount() {
    // final now = DateTime.now();
    return meetings.where((meeting) => meeting.endTime.isBefore(selectedDay)).length;
  }

  int getUpcomingMeetingsCount() {
    // final now = DateTime.now();
    return meetings.where((meeting) => meeting.endTime.isAfter(selectedDay)).length;
  }

  List<MeetingModel> getEndedMeetings() {
    // final now = DateTime.now();
    return meetings.where((meeting) => meeting.endTime.isBefore(selectedDay)).toList();
  }

  List<MeetingModel> getUpcomingMeetings() {
    // final now = DateTime.now();
    return meetings.where((meeting) => meeting.endTime.isAfter(selectedDay)).toList();
  }
}

enum CalendarView { month, week, day }