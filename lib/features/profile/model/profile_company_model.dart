class ProfileCompanyModel {
  final String companyName, brief, foundedAt, website, phone, email;

  ProfileCompanyModel({
    required this.companyName, 
    required this.brief, 
    required this.foundedAt, 
    required this.website, 
    required this.phone, 
    required this.email,
  });

  factory ProfileCompanyModel.fromJson(Map json) {
    return ProfileCompanyModel(
      companyName: json['company'] ?? '', 
      brief: json['description'] ?? '', 
      foundedAt: json['founded date'] ?? '', 
      website: json['website'] ?? '', 
      phone: json['phone'] ?? '', 
      email: json['email'] ?? '',
    );
  }
}