class LeaveTypesModel {
  final String leaveType;
  final int availableLeaves;

  LeaveTypesModel({required this.leaveType, required this.availableLeaves});

  factory LeaveTypesModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypesModel(
      leaveType: json['leave_type'],
      availableLeaves: int.tryParse(json['remaining_leaves'].toString().split('.')[0]) ?? 0,
    );
  }
}