import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import 'meeting_details_page.dart';

class MeetingsPage extends StatefulWidget {
  const MeetingsPage({super.key});

  @override
  State<MeetingsPage> createState() => _MeetingsPageState();
}

class _MeetingsPageState extends State<MeetingsPage> {
  late DateTime _currentMonth;
  late DateTime _currentWeekStart;
  late DateTime _selectedDay;
  String _viewMode = 'Weekly';
  OverlayEntry? _dropdownOverlay;
  
  // Sample meetings data (colorIndex will be auto-assigned)
  final List<Map<String, dynamic>> _meetings = [
    {
      'title': 'Team Standup',
      'date': DateTime(2025, 11, 6),
      'time': '09:00 - 09:30',
      'duration': '30 min',
      'attendees': ['JD', 'SM', 'AL'],
    },
    {
      'title': 'Product Review',
      'date': DateTime(2025, 11, 6),
      'time': '14:00 - 15:30',
      'duration': '1h 30 min',
      'attendees': ['TB', 'LG', 'KM', 'AR', 'JS'],
    },
    {
      'title': 'Client Call',
      'date': DateTime(2025, 11, 7),
      'time': '11:00 - 12:00',
      'duration': '1h',
      'attendees': ['DL', 'PK'],
    },
    {
      'title': 'Design Workshop',
      'date': DateTime(2025, 11, 8),
      'time': '10:00 - 11:30',
      'duration': '1h 30 min',
      'attendees': ['CT', 'AP', 'RM'],
    },
    {
      'title': 'Sprint Planning',
      'date': DateTime(2025, 11, 9),
      'time': '13:00 - 15:00',
      'duration': '2h',
      'attendees': ['KS', 'NJ', 'MW', 'AB'],
    },
    {
      'title': 'Sprint Planning',
      'date': DateTime(2025, 11, 12),
      'time': '13:00 - 15:00',
      'duration': '2h',
      'attendees': ['KS', 'NJ', 'MW', 'AB'],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Start with current date
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _currentWeekStart = _getSundayOfWeek(now);
    _selectedDay = now;
  }

  @override
  void dispose() {
    _dropdownOverlay?.remove();
    super.dispose();
  }

  void _showDropdown(BuildContext context, GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _dropdownOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible barrier to close dropdown
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          // Dropdown menu
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height + 4,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.popupShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ['Daily', 'Weekly', 'Monthly'].map((mode) {
                    final isSelected = mode == _viewMode;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _viewMode = mode;
                        });
                        _hideDropdown();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.lightGrey : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mode,
                              style: AppTypography.p14(
                                color: isSelected ? AppColors.darkText : AppColors.darkText,
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                size: 18,
                                color: AppColors.unreadDot,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_dropdownOverlay!);
  }

  void _hideDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
    setState(() {});
  }

  /// Get the Sunday of the week containing the given date
  /// DateTime.weekday: Monday=1, Tuesday=2, ..., Sunday=7
  DateTime _getSundayOfWeek(DateTime date) {
    // If it's already Sunday (weekday=7), return the same date
    // Otherwise, subtract days to get to the previous Sunday
    int daysToSubtract = date.weekday % 7;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysToSubtract));
  }

  List<DateTime> _getWeekDays() {
    DateTime weekStart;
    
    if (_viewMode == 'Daily') {
      // In Daily mode, show the week containing the selected day
      weekStart = _getSundayOfWeek(_selectedDay);
    } else {
      // In Weekly mode, use the current week start
      weekStart = _currentWeekStart;
    }
    
    return List.generate(7, (i) => weekStart.add(Duration(days: i)));
  }

  List<List<DateTime>> _getMonthDays() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    
    // Get the Sunday before or on the first day of the month
    final calendarStart = _getSundayOfWeek(firstDay);
    
    // Generate 6 weeks (42 days) to cover the entire month
    final totalDays = 42;
    final allDays = List.generate(totalDays, (i) => calendarStart.add(Duration(days: i)));
    
    // Group into weeks
    final weeks = <List<DateTime>>[];
    for (var i = 0; i < allDays.length; i += 7) {
      weeks.add(allDays.sublist(i, i + 7));
    }
    
    return weeks;
  }

  bool _isDaySelected(DateTime day) {
    if (_viewMode == 'Daily') {
      // For Daily mode, select the currently navigated day
      return day.day == _selectedDay.day && day.month == _selectedDay.month && day.year == _selectedDay.year;
    } else if (_viewMode == 'Weekly' || _viewMode == 'Monthly') {
      // Sun to Thu (0-4)
      return day.weekday % 7 <= 4;
    }
    return false;
  }

  int _getColorIndexForMeeting(int meetingIndex) {
    // Cycle through colors based on meeting index
    return meetingIndex % AppColors.meetingColors.length;
  }

  List<Map<String, dynamic>> _getMeetingsForDay(DateTime day) {
    return _meetings
        .where((m) => 
            m['date'].day == day.day && 
            m['date'].month == day.month &&
            m['date'].year == day.year)
        .toList();
  }

  /// Get filtered meetings based on current view mode
  List<Map<String, dynamic>> _getFilteredMeetings() {
    if (_viewMode == 'Daily') {
      // Show only meetings for the selected day
      return _meetings.where((m) {
        final meetingDate = m['date'] as DateTime;
        return meetingDate.year == _selectedDay.year &&
               meetingDate.month == _selectedDay.month &&
               meetingDate.day == _selectedDay.day;
      }).toList();
    } else if (_viewMode == 'Weekly') {
      // Show only meetings for the current week
      final weekStart = _currentWeekStart;
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      return _meetings.where((m) {
        final meetingDate = m['date'] as DateTime;
        return meetingDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
               meetingDate.isBefore(weekEnd.add(const Duration(days: 1)));
      }).toList();
    } else {
      // Monthly - show only meetings for the current month
      return _meetings.where((m) {
        final meetingDate = m['date'] as DateTime;
        return meetingDate.year == _currentMonth.year &&
               meetingDate.month == _currentMonth.month;
      }).toList();
    }
  }

  void _navigatePrevious() {
    setState(() {
      if (_viewMode == 'Monthly') {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      } else if (_viewMode == 'Daily') {
        // Daily - navigate day by day
        _selectedDay = _selectedDay.subtract(const Duration(days: 1));
      } else {
        // Weekly - navigate week
        _currentWeekStart = _currentWeekStart.subtract(const Duration(days: 7));
      }
    });
  }

  void _navigateNext() {
    setState(() {
      if (_viewMode == 'Monthly') {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      } else if (_viewMode == 'Daily') {
        // Daily - navigate day by day
        _selectedDay = _selectedDay.add(const Duration(days: 1));
      } else {
        // Weekly - navigate week
        _currentWeekStart = _currentWeekStart.add(const Duration(days: 7));
      }
    });
  }

  String _getMonthYear() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }

  String _getDayName(int weekday) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final weekDays = _getWeekDays();
    final monthWeeks = _getMonthDays();
    final dropdownKey = GlobalKey();

    return BaseScaffold(
      appBar: const SecondaryAppBar(title: 'Meetings'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month navigation and view mode dropdown
              Row(
                children: [
                  // Month title and arrows
                  Row(
                    children: [
                      Text(
                        _getMonthYear(),
                        style: AppTypography.p16(),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _navigatePrevious,
                        icon: const Icon(Icons.chevron_left),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: _navigateNext,
                        icon: const Icon(Icons.chevron_right),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  
                  // View mode dropdown
                  GestureDetector(
                    key: dropdownKey,
                    onTap: () => _showDropdown(context, dropdownKey),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                        boxShadow: AppShadows.popupShadow,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _viewMode,
                            style: AppTypography.p14(),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            _dropdownOverlay != null 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.darkText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Calendar section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.defaultShadow,
                ),
                child: _viewMode == 'Monthly' 
                    ? _buildMonthCalendar(monthWeeks)
                    : _buildWeekCalendar(weekDays),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Meeting records (filtered based on view mode)
              Builder(
                builder: (context) {
                  final filteredMeetings = _getFilteredMeetings();
                  
                  if (filteredMeetings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          'No meetings scheduled',
                          style: AppTypography.helperText(),
                        ),
                      ),
                    );
                  }
                  
                  return Column(
                    children: filteredMeetings.map((meeting) {
                      // Find the original index to maintain consistent colors
                      final originalIndex = _meetings.indexOf(meeting);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MeetingRecord(
                          title: meeting['title'],
                          date: meeting['date'],
                          time: meeting['time'],
                          duration: meeting['duration'],
                          attendees: List<String>.from(meeting['attendees']),
                          colorIndex: _getColorIndexForMeeting(originalIndex),
                          onEyeTap: () {
                            // Navigate to meeting details page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MeetingDetailsPage(
                                  title: meeting['title'],
                                  date: meeting['date'],
                                  time: meeting['time'],
                                  duration: meeting['duration'],
                                  attendees: List<String>.from(meeting['attendees']),
                                  colorIndex: _getColorIndexForMeeting(originalIndex),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekCalendar(List<DateTime> weekDays) {
    return Column(
      children: [
        // Day names
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((day) {
            final isSelected = _isDaySelected(day);
            final dayMeetings = _getMeetingsForDay(day);
            
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      _getDayName(day.weekday),
                      style: AppTypography.helperTextSmall(
                        color: isSelected ? AppColors.unreadDot : AppColors.helperText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.unreadBg : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppBorderRadius.radius4),
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: AppTypography.p14(
                            color: isSelected ? AppColors.unreadDot : AppColors.darkText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Dots for meetings - one dot per meeting
                    SizedBox(
                      height: 10,
                      child: dayMeetings.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: dayMeetings.asMap().entries.map((entry) {
                                final meetingIndex = _meetings.indexOf(entry.value);
                                return Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.meetingColors[_getColorIndexForMeeting(meetingIndex)],
                                    shape: BoxShape.circle,
                                  ),
                                );
                              }).toList(),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMonthCalendar(List<List<DateTime>> weeks) {
    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTypography.helperTextSmall(color: AppColors.helperText),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Calendar grid
        ...weeks.map((week) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: week.map((day) {
                final isCurrentMonth = day.month == _currentMonth.month;
                final isSelected = _isDaySelected(day) && isCurrentMonth;
                final dayMeetings = _getMeetingsForDay(day);
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.unreadBg : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppBorderRadius.radius4),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: AppTypography.p14(
                                color: !isCurrentMonth 
                                    ? AppColors.helperText.withOpacity(0.3)
                                    : isSelected 
                                        ? AppColors.unreadDot 
                                        : AppColors.darkText,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Dots for meetings
                        SizedBox(
                          height: 10,
                          child: dayMeetings.isNotEmpty && isCurrentMonth
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: dayMeetings.asMap().entries.map((entry) {
                                    final meetingIndex = _meetings.indexOf(entry.value);
                                    return Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                      decoration: BoxDecoration(
                                        color: AppColors.meetingColors[_getColorIndexForMeeting(meetingIndex)],
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList(),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _MeetingRecord extends StatefulWidget {
  final String title;
  final DateTime date;
  final String time;
  final String duration;
  final List<String> attendees;
  final int colorIndex;
  final VoidCallback onEyeTap;

  const _MeetingRecord({
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.attendees,
    required this.colorIndex,
    required this.onEyeTap,
  });

  @override
  State<_MeetingRecord> createState() => _MeetingRecordState();
}

class _MeetingRecordState extends State<_MeetingRecord> {
  bool _isPressed = false;

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.meetingColors[widget.colorIndex].withOpacity(0.12);
    final maxVisibleAttendees = 4;
    final visibleAttendees = widget.attendees.take(maxVisibleAttendees).toList();
    final remainingCount = widget.attendees.length - maxVisibleAttendees;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            // Title and eye icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppTypography.p16(),
                  ),
                ),
                GestureDetector(
                  onTapDown: (_) => setState(() => _isPressed = true),
                  onTapUp: (_) {
                    setState(() => _isPressed = false);
                    widget.onEyeTap();
                  },
                  onTapCancel: () => setState(() => _isPressed = false),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _isPressed ? Colors.white.withOpacity(0.48) : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/eye.svg',
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 8),

          // Date
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.helperText),
              const SizedBox(width: 8),
              Text(
                _formatDate(widget.date),
                style: AppTypography.helperText(),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Time and duration
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: AppColors.helperText),
              const SizedBox(width: 8),
              Text(
                '${widget.time} • ${widget.duration}',
                style: AppTypography.helperText(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Attendees
          SizedBox(
            height: 32,
            child: Stack(
              children: [
                ...visibleAttendees.asMap().entries.map((entry) {
                  final index = entry.key;
                  final initials = entry.value;
                  
                  return Positioned(
                    left: index * 24.0, // Each avatar shifts 24px (overlapping by 8px)
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.meetingColors[widget.colorIndex],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (remainingCount > 0)
                  Positioned(
                    left: visibleAttendees.length * 24.0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.meetingColors[widget.colorIndex],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+$remainingCount',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

