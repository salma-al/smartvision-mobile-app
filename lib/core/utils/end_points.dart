class EndPoints {
  ///login
  static const String login = 'login';

  ///save fcm token
  static const String saveToken = 'save_fcm_token';

  ///profile
  static const String getProfile = 'get_employee_details';
  static const String getCompany = 'get_company_details';
  static const String getSalaries = 'get_salary_slips';
  static const String getSalaryDetails = 'get_salary_slip_details';

  ///check in/out
  static const String lastCheckInOut = 'get_employee_shift_and_checkin';
  static const String checkInOut = 'mark_attendance';

  ///leaves
  static const String getLeaves = 'get_available_leaves';
  static const String requestLeave = 'leave_shift_request';
  static const String requestOvertime = 'overtime_request';

  ///attendance
  static const String getAttendance = 'calculate_employee_monthly_attendance'; //send with day for current day statistics and without day for whole month

  ///follow up
  static const String getFollowUp = 'make_follow_up';

  ///reports
  ///requests report
  static const String getRequestsReport = 'get_employee_data';
  ///attendance report
  static const String getAttendaceReport = 'get_employee_attendance';
  ///overtime report
  static const String getOvertimeReport = 'get_overtime_requests';

  ///notifications
  static const String getNotifications = 'get_notifications';
  ///announcements
  static const String getAnnouncements = 'get_announcements';

  ///requests
  static const String availableRequests = 'check_approval_screen_access';
  static const String getRequests = 'get_pending_requests';
  static const String updateRequest = 'update_request_status';
}