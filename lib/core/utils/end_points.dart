class EndPoints {
  ///login (done)
  static const String login = 'auth.authentication.login';

  ///save fcm token (done)
  static const String saveToken = 'utils.fcm_notifications.save_fcm_token';
  
  ///profile
  static const String profileMainData = 'employee.profile.get_employee_Profile';
  static const String getProfile = 'employee.profile.get_employee_details'; //need active key,
  static const String getCompany = 'employee.profile.get_company_details';
  static const String getSalaries = 'payroll.salary.get_salary_slips';
  static const String getSalaryDetails = 'payroll.salary.get_salary_slip_details';

  ///check in/out (done)
  static const String lastCheckInOut = 'employee.attendance.get_employee_shift_and_checkin';
  static const String checkInOut = 'employee.attendance.mark_attendance';

  ///leaves (done)
  static const String leaveHistory = 'requests.leave_requests.get_employee_leave_data';
  static const String leaveCreate = 'requests.leave_requests.create_leave_request';
  ///shifts (done)
  static const String shiftHistory = 'requests.leave_requests.get_employee_shift_data';
  static const String shiftCreate = 'requests.leave_requests.create_shift_request';
  ///overtime (done)
  static const String overtimeHistory = 'requests.overtime_requests.get_overtime_requests';
  static const String overtimeCreate = 'requests.overtime_requests.overtime_request';

  ///attendance (done)
  static const String getAttendance = 'employee.statistics.calculate_employee_monthly_attendance';

  ///notifications (done)
  static const String getNotifications = 'communications.notifications.get_notifications';
  ///announcements (done)
  static const String getAnnouncements = 'communications.announcements.get_announcements';

  ///requests (done)
  static const String availableRequests = 'approvals.approval_access.check_approval_screen_access';
  static const String getRequests = 'approvals.approval_access.get_pending_requests';
  static const String updateRequest = 'approvals.approval_workflow.update_request_status';
}