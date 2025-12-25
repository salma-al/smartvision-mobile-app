class HomeModel {
  final bool showRequests;
  final String lastCheckIn;
  final int unreadEmailsCount, unreadRequestsCount;

  HomeModel({required this.showRequests, required this.lastCheckIn, required this.unreadEmailsCount, required this.unreadRequestsCount});

  factory HomeModel.fromJson(Map json) {
    return HomeModel(
      showRequests: json['has_access'],
      lastCheckIn: json['last_checkin'] ?? '',
      unreadEmailsCount: json['unseen_emails_count'],
      unreadRequestsCount: json['pending_requests_count'],
    );
  }
}