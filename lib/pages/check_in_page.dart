import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  bool _isCheckedIn = false;
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  Timer? _timer;
  Duration _workedDuration = Duration.zero;
  List<Map<String, DateTime?>> _timeLogs = []; // List of check-in/check-out pairs

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_checkInTime != null && _checkOutTime == null) {
        setState(() {
          _workedDuration = DateTime.now().difference(_checkInTime!);
        });
      }
    });
  }

  void _handleCheckIn() {
    setState(() {
      _isCheckedIn = true;
      _checkInTime = DateTime.now();
      _checkOutTime = null;
    });
    _startTimer();
  }

  void _handleCheckOut() {
    if (_checkInTime != null) {
      // Capture values BEFORE setState to ensure they're preserved
      final checkInTimestamp = _checkInTime!.millisecondsSinceEpoch;
      final checkOutTimestamp = DateTime.now().millisecondsSinceEpoch;
      
      setState(() {
        // Create the log entry first with captured timestamps
        final logEntry = {
          'checkIn': DateTime.fromMillisecondsSinceEpoch(checkInTimestamp),
          'checkOut': DateTime.fromMillisecondsSinceEpoch(checkOutTimestamp),
        };
        
        // Add to time logs
        _timeLogs.add(logEntry);
        
        // Debug: Print the logs to verify
        print('Time logs count: ${_timeLogs.length}');
        for (var i = 0; i < _timeLogs.length; i++) {
          print('Log $i: CheckIn=${_timeLogs[i]['checkIn']}, CheckOut=${_timeLogs[i]['checkOut']}');
        }
        
        // Calculate worked duration for this session
        _workedDuration = Duration(milliseconds: checkOutTimestamp - checkInTimestamp);
        
        // Reset for next check-in
        _isCheckedIn = false;
        _checkInTime = null;
        _checkOutTime = null;
      });
      _timer?.cancel();
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $amPm';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}:${minutes.toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = _formatDate(now);
    
    // Calculate total worked duration including current session and all previous logs
    Duration totalWorkedDuration = Duration.zero;
    
    // Add all completed time logs
    for (var log in _timeLogs) {
      if (log['checkIn'] != null && log['checkOut'] != null) {
        totalWorkedDuration += log['checkOut']!.difference(log['checkIn']!);
      }
    }
    
    // Add current session if checked in
    if (_isCheckedIn && _checkInTime != null) {
      totalWorkedDuration += DateTime.now().difference(_checkInTime!);
    }
    
    // Calculate work progress (9 hour workday)
    const totalWorkMinutes = 9 * 60; // 9 hours
    final workedMinutes = totalWorkedDuration.inMinutes;
    final progressPercent = (workedMinutes / totalWorkMinutes * 100).clamp(0, 100);
    
    final remainingMinutes = (totalWorkMinutes - workedMinutes).clamp(0, totalWorkMinutes);
    final remainingDuration = Duration(minutes: remainingMinutes);

    return BaseScaffold(
      appBar: const SecondaryAppBar(
        title: 'Check In',
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePaddingHorizontal,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date section with custom spacing (3px from app bar)
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today_outlined, 
                    size: 16, color: AppColors.lightText),
                const SizedBox(width: 6),
                Text(dateStr, style: AppTypography.helperText()),
              ],
            ),
            const SizedBox(height: 16),

            // Company Info Cards
            _buildInfoCards(),
            const SizedBox(height: 16),

            // Check In/Out Section
            _buildCheckInOutSection(),
            const SizedBox(height: 16),

            // Today's Progress (always shown)
            _buildTodaysProgress(progressPercent, remainingDuration, totalWorkedDuration),
            const SizedBox(height: 16),

            // Time Log (shown when checked in or has logs)
            if (_isCheckedIn || _timeLogs.isNotEmpty) _buildTimeLog(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 
                    'July', 'August', 'September', 'October', 'November', 'December'];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  Widget _buildInfoCards() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoItem(
              icon: 'assets/icons/case.svg',
              iconColor: AppColors.red,
              iconBg: const Color(0x14CB1933),
              label: 'Company',
              value: 'SVG',
            ),
          ),

          Expanded(
            child: _InfoItem(
              icon: 'assets/icons/clock_grey.svg',
              iconColor: AppColors.red,
              iconBg: const Color(0x14CB1933),
              label: 'Shift Hours',
              value: '9 AM - 6 PM',
            ),
          ),

          Expanded(
            child: _InfoItem(
              icon: 'assets/icons/note.svg',
              iconColor: AppColors.red,
              iconBg: const Color(0x14CB1933),
              label: 'Break Hours',
              value: '1 PM - 2 PM',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInOutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        children: [
          // Icon and title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                size: 20,
                color: AppColors.darkText,
              ),
              const SizedBox(width: 8),
              Text(
                _isCheckedIn ? 'Check In Time' : 'Tap to Check In',
                style: AppTypography.p16(),
              ),
            ],
          ),
          
          // Time display
          if (_isCheckedIn && _checkInTime != null) ...[
            const SizedBox(height: 16),
            Text(
              _formatTimeWithAMPM(_checkInTime!),
              style: const TextStyle(
                color: Color(0xFF0A0A0A),
                fontFamily: 'DM Sans',
                fontSize: 36,
                fontWeight: FontWeight.w400,
                height: 40 / 36,
                letterSpacing: 5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Check In/Out button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isCheckedIn ? _handleCheckOut : _handleCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCheckedIn 
                    ? const Color(0xFF991B1B)
                    : const Color(0xFF065F46),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, 
                      size: 20, color: AppColors.white),
                  const SizedBox(width: 8),
                  Text(
                    _isCheckedIn ? 'Check Out' : 'Check In',
                    style: AppTypography.p16(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTimeWithAMPM(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $amPm';
  }

  Widget _buildTodaysProgress(num progressPercent, Duration remaining, Duration totalWorked) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Progress', style: AppTypography.p16()),
          const SizedBox(height: 16),
          
          // Progress label and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Work Progress', style: AppTypography.helperTextSmall()),
              Text('${progressPercent.toInt()}%', 
                  style: AppTypography.helperTextSmall()),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressPercent / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkText),
            ),
          ),
          const SizedBox(height: 16),
          
          // Time stats
          Row(
            children: [
              Expanded(
                child: _TimeStatItem(
                  label: 'Worked',
                  value: (_isCheckedIn || _timeLogs.isNotEmpty)
                      ? _formatDurationShort(totalWorked)
                      : '--:--:--',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeStatItem(
                  label: 'Remaining',
                  value: (_isCheckedIn || _timeLogs.isNotEmpty)
                      ? _formatDurationShort(remaining)
                      : '--:--:--',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeStatItem(
                  label: 'Total',
                  value: '9:00:00',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current session (if checked in) - in its own card with title
        if (_isCheckedIn && _checkInTime != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
              boxShadow: AppShadows.defaultShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time Log', style: AppTypography.p16()),
                const SizedBox(height: 16),
                _TimeLogItem(
                  icon: SvgPicture.asset(
                    'assets/icons/check.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn),
                  ),
                  iconColor: AppColors.green,
                  label: 'Check In Time',
                  time: _formatTime(_checkInTime),
                ),
                const SizedBox(height: 12),
                _TimeLogItem(
                  icon: const Icon(Icons.cancel, size: 18, color: AppColors.red),
                  iconColor: AppColors.red,
                  label: 'Check Out Time',
                  time: '--:--',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Previous time logs (reverse order - most recent first)
        // Each pair in its own card with title
        for (int i = _timeLogs.length - 1; i >= 0; i--) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
              boxShadow: AppShadows.defaultShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time Log', style: AppTypography.p16()),
                const SizedBox(height: 16),
                _TimeLogItem(
                  icon: SvgPicture.asset(
                    'assets/icons/check_green.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn),
                  ),
                  iconColor: AppColors.green,
                  label: 'Check In Time',
                  time: _formatTime(_timeLogs[i]['checkIn']),
                ),
                const SizedBox(height: 12),
                _TimeLogItem(
                  icon: SvgPicture.asset(
                    'assets/icons/X_red.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                  ),
                  iconColor: AppColors.red,
                  label: 'Check Out Time',
                  time: _formatTime(_timeLogs[i]['checkOut']),
                ),
              ],
            ),
          ),
          if (i > 0) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.helperTextSmall()),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.helperTextXSmall()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeStatItem extends StatelessWidget {
  final String label;
  final String value;

  const _TimeStatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.helperTextSmall()),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.helperTextXSmall()),
        ],
      ),
    );
  }
}

class _TimeLogItem extends StatelessWidget {
  final Widget icon;
  final Color iconColor;
  final String label;
  final String time;

  const _TimeLogItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTypography.helperTextSmall()),
          ),
          Text(time, style: AppTypography.helperTextSmall()),
        ],
      ),
    );
  }
}

