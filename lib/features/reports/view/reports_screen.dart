import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/features/reports/components/reports_component.dart';
import 'package:smart_vision/features/reports/model/reports_model.dart';
import 'package:smart_vision/features/reports/view/report_attendance_screen.dart';
import 'package:smart_vision/features/reports/view/report_overtime_screen.dart';
import 'package:smart_vision/features/reports/view/report_requests_screen.dart';

class ReportsScreen extends StatelessWidget {
  final List<ReportsModel> reports = [
    ReportsModel(title: 'Attendance Report', screen: ReportAttendance(), image: 'assets/images/attendance_report.png'),
    ReportsModel(title: 'Requests Report', screen: const ReportRequests(), image: 'assets/images/requests_report.png'),
    ReportsModel(title: 'Overtime Report', screen: const ReportOvertimeScreen(), image: 'assets/images/overtime_report.png'),
  ];

  ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...reports.map((e) => ReportsComponent(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => e.screen)),
                title: e.title, 
                image: e.image,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
