import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/colors.dart';
import '../view_model/cubit/meetings_cubit.dart';
import '../model/meeting_model.dart';
import 'meeting_details_screen.dart';

class MeetingsCalendarScreen extends StatelessWidget {
  const MeetingsCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingsCubit()..loadMeetings(),
      child: BlocBuilder<MeetingsCubit, MeetingsState>(
        builder: (context, state) {
          final cubit = MeetingsCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Meetings Calendar'),
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.calendar_view_month),
                  onPressed: () => cubit.changeCalendarView(CalendarView.month),
                  color: cubit.currentView == CalendarView.month ? Colors.white : Colors.white70,
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_view_week),
                  onPressed: () => cubit.changeCalendarView(CalendarView.week),
                  color: cubit.currentView == CalendarView.week ? Colors.white : Colors.white70,
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_view_day),
                  onPressed: () => cubit.changeCalendarView(CalendarView.day),
                  color: cubit.currentView == CalendarView.day ? Colors.white : Colors.white70,
                ),
              ],
            ),
            body: Column(
              children: [
                _buildCalendarHeader(cubit),
                Expanded(
                  child: _buildCalendarView(context, cubit),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendarHeader(MeetingsCubit cubit) {
    final headerFormat = cubit.currentView == CalendarView.month
        ? DateFormat('MMMM yyyy')
        : cubit.currentView == CalendarView.week
            ? DateFormat('MMMM d') 
            : DateFormat('EEEE, MMMM d');
            
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.mainColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              // final now = cubit.focusedDay;
              DateTime newDate;
              
              if (cubit.currentView == CalendarView.month) {
                // newDate = DateTime(now.year, now.month - 1, now.day);
                newDate = cubit.selectedDay;
              } else if (cubit.currentView == CalendarView.week) {
                newDate = cubit.selectedDay.subtract(const Duration(days: 7));
              } else {
                newDate = cubit.selectedDay.subtract(const Duration(days: 1));
              }
              
              cubit.updateFocusedDay(newDate);
            },
          ),
          Text(
            headerFormat.format(cubit.selectedDay),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              final now = cubit.focusedDay;
              DateTime newDate;
              
              if (cubit.currentView == CalendarView.month) {
                newDate = DateTime(now.year, now.month + 1, now.day);
              } else if (cubit.currentView == CalendarView.week) {
                newDate = now.add(const Duration(days: 7));
              } else {
                newDate = now.add(const Duration(days: 1));
              }
              
              cubit.updateFocusedDay(newDate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(BuildContext context, MeetingsCubit cubit) {
    switch (cubit.currentView) {
      case CalendarView.month:
        return _buildMonthView(context, cubit);
      case CalendarView.week:
        return _buildWeekView(cubit);
      case CalendarView.day:
        return _buildDayView(cubit);
    }
  }

  Widget _buildMonthView(BuildContext context, MeetingsCubit cubit) {
    final daysInMonth = DateTime(cubit.focusedDay.year, cubit.focusedDay.month + 1, 0).day;
    final firstDayOfMonth = DateTime(cubit.focusedDay.year, cubit.focusedDay.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday;
    
    // Adjust for Sunday as first day of week (0-indexed)
    final adjustedFirstWeekday = firstWeekdayOfMonth % 7;
    
    return Column(  
      children: [
        // Weekday headers
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: List.generate(7, (index) {
              final weekdayName = DateFormat('E').format(DateTime(2023, 1, index + 1));
              return Expanded(
                child: Center(
                  child: Text(
                    weekdayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }),
          ),
        ),
        // Calendar grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 weeks × 7 days
            itemBuilder: (context, index) {
              // Calculate the day number
              final dayNumber = index - adjustedFirstWeekday + 1;
              
              // Check if the day is in the current month
              final isCurrentMonth = dayNumber > 0 && dayNumber <= daysInMonth;
              
              // Create the date for this cell
              final date = isCurrentMonth
                  ? DateTime(cubit.focusedDay.year, cubit.focusedDay.month, dayNumber)
                  : null;
              
              // Check if this date has meetings
              final hasMeetings = isCurrentMonth && cubit.getMeetingsForDay(date!).isNotEmpty;
              
              // Check if this is the selected day
              final isSelected = isCurrentMonth &&
                  date!.year == cubit.selectedDay.year &&
                  date.month == cubit.selectedDay.month &&
                  date.day == cubit.selectedDay.day;
              
              // Check if this is today
              final now = DateTime.now();
              final isToday = isCurrentMonth &&
                  date!.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
              
              return GestureDetector(
                onTap: isCurrentMonth
                    ? () {
                        cubit.selectDay(date!);
                        // cubit.changeCalendarView(CalendarView.day);
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.mainColor.withValues(alpha: 0.2)
                        : isToday
                            ? AppColors.lightColor
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isToday
                        ? Border.all(color: AppColors.mainColor, width: 1)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isCurrentMonth ? dayNumber.toString() : '',
                        style: TextStyle(
                          fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isCurrentMonth ? Colors.black : Colors.grey,
                        ),
                      ),
                      if (hasMeetings)
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Statistics section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Meeting Statistics',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatisticItem(
                      context,
                      'Ended',
                      cubit.getEndedMeetingsCount().toString(),
                      AppColors.mainColor,
                      Icons.event_available,
                      () => _showMeetingsList(context, cubit.getEndedMeetings(), 'Ended Meetings'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatisticItem(
                      context,
                      'Upcoming',
                      cubit.getUpcomingMeetingsCount().toString(),
                      AppColors.darkColor,
                      Icons.event,
                      () => _showMeetingsList(context, cubit.getUpcomingMeetings(), 'Upcoming Meetings'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticItem(BuildContext context, String title, String count, Color color, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Text(
                  count,
                  style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekView(MeetingsCubit cubit) {
    // Find the first day of the week containing the focused day
    final firstDayOfWeek = cubit.focusedDay.subtract(Duration(days: cubit.focusedDay.weekday % 7));
    
    return Column(
      children: [
        // Weekday headers with dates
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: List.generate(7, (index) {
              final date = firstDayOfWeek.add(Duration(days: index));
              final isToday = _isSameDay(date, DateTime.now());
              final isSelected = _isSameDay(date, cubit.selectedDay);
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    cubit.selectDay(date);
                    // cubit.changeCalendarView(CalendarView.day);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.mainColor.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          DateFormat('E').format(date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isToday ? AppColors.mainColor : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isToday ? AppColors.mainColor : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isToday ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        // Week events list
        Expanded(
          child: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, dayIndex) {
              final date = firstDayOfWeek.add(Duration(days: dayIndex));
              final meetings = cubit.getMeetingsForDay(date);
              
              if (meetings.isEmpty) {
                return Container(); // Skip days with no meetings
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('EEEE, MMMM d').format(date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...meetings.map((meeting) => _buildMeetingTile(context, meeting)),
                  const Divider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDayView(MeetingsCubit cubit) {
    final meetings = cubit.getMeetingsForDay(cubit.selectedDay);
    
    return Column(
      children: [
        // Time slots
        Expanded(
          child: ListView.builder(
            itemCount: 24, // 24 hours
            itemBuilder: (context, hourIndex) {
              final hour = hourIndex;
              final timeString = DateFormat('h a').format(DateTime(2023, 1, 1, hour));
              
              // Find meetings that occur during this hour
              final hourMeetings = meetings.where((meeting) {
                return meeting.startTime.hour <= hour && meeting.endTime.hour >= hour;
              }).toList();
              
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time indicator
                  SizedBox(
                    width: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        timeString,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  // Hour divider
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: VerticalDivider(width: 1),
                  ),
                  // Meetings for this hour
                  Expanded(
                    child: Column(
                      children: [
                        const Divider(height: 1),
                        ...hourMeetings.map((meeting) => _buildMeetingTile(context, meeting)),
                        if (hourMeetings.isEmpty) const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingTile(BuildContext context, MeetingModel meeting) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeetingDetailsScreen(meeting: meeting),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.mainColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.mainColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meeting.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  meeting.isAllDay
                      ? 'All day'
                      : '${DateFormat('h:mm a').format(meeting.startTime)} - ${DateFormat('h:mm a').format(meeting.endTime)}',
                  style: TextStyle(color: AppColors.darkColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              meeting.location,
              style: TextStyle(color: AppColors.darkColor),
            ),
          ],
        ),
      ),
    );
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showMeetingsList(BuildContext context, List<MeetingModel> meetings, String title) {
    final cubit = MeetingsCubit.get(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_view_day),
                    onPressed: () {
                      Navigator.pop(context);
                      cubit.changeCalendarView(CalendarView.day);
                    },
                    tooltip: 'Switch to Day View',
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: meetings.isEmpty
                  ? const Center(child: Text('No meetings found'))
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: meetings.length,
                      itemBuilder: (context, index) {
                        final meeting = meetings[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            cubit.selectDay(meeting.startTime);
                            cubit.changeCalendarView(CalendarView.day);
                          },
                          child: _buildMeetingTile(context, meeting),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}