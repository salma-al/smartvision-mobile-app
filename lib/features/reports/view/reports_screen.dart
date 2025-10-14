import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/colors.dart';
// import 'package:smart_vision/features/meetings/view/meetings_calendar_screen.dart';
import 'package:smart_vision/features/reports/components/reports_component.dart';
import 'package:smart_vision/features/reports/model/reports_model.dart';
import 'package:smart_vision/features/reports/view/report_attendance_screen.dart';
import 'package:smart_vision/features/reports/view/report_overtime_screen.dart';
import 'package:smart_vision/features/reports/view/report_requests_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ReportsModel> reports = [
      ReportsModel(title: 'Attendance Report', screen: ReportAttendance(), image: 'assets/images/attendance_report.png'),
      ReportsModel(title: 'Requests Report', screen: const ReportRequests(), image: 'assets/images/requests_report.png'),
      ReportsModel(title: 'Overtime Report', screen: const ReportOvertimeScreen(), image: 'assets/images/overtime_report.png'),
      // ReportsModel(title: 'Meetings Calendar', screen: const MeetingsCalendarScreen(), image: 'assets/images/meetings.png'),
      // ReportsModel(title: 'My Meetings', screen: const MeetingsCalendarScreen(), image: 'assets/images/my_meetings.png'),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Reports', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: reports.length,
          itemBuilder: (context, index) {
            ReportsModel rep = reports[index];
            return ReportsComponent(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => rep.screen)), 
              title: rep.title, 
              image: rep.image,
            );
          },
        ),
      ),
    );
  }
}