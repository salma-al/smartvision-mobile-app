class EmailModel {
  final String id;
  final String subject;
  final String body;
  final String senderName;
  final String senderEmail;
  final List<String> recipientEmails;
  final List<String>? ccEmails;
  final List<String>? bccEmails;
  final DateTime date;
  final List<AttachmentModel>? attachments;
  final bool isRead;
  final bool isStarred;
  final bool isDraft;
  final bool isSent;
  final DateTime? scheduledTime;
  final String? signature;
  final bool isSignatureImage;

  EmailModel({
    required this.id,
    required this.subject,
    required this.body,
    required this.senderName,
    required this.senderEmail,
    required this.recipientEmails,
    this.ccEmails,
    this.bccEmails,
    required this.date,
    this.attachments,
    required this.isRead,
    required this.isStarred,
    required this.isDraft,
    required this.isSent,
    this.scheduledTime,
    this.signature,
    this.isSignatureImage = false,
  });

  factory EmailModel.fromJson(Map<String, dynamic> json) {
    return EmailModel(
      id: json['id'] ?? '',
      subject: json['subject'] ?? '',
      body: json['body'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderEmail: json['sender_email'] ?? '',
      recipientEmails: List<String>.from(json['recipient_emails'] ?? []),
      ccEmails: json['cc_emails'] != null ? List<String>.from(json['cc_emails']) : null,
      bccEmails: json['bcc_emails'] != null ? List<String>.from(json['bcc_emails']) : null,
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      attachments: json['attachments'] != null
          ? List<AttachmentModel>.from(
              json['attachments'].map((x) => AttachmentModel.fromJson(x)))
          : null,
      isRead: json['is_read'] ?? false,
      isStarred: json['is_starred'] ?? false,
      isDraft: json['is_draft'] ?? false,
      isSent: json['is_sent'] ?? false,
      scheduledTime: json['scheduled_time'] != null
          ? DateTime.parse(json['scheduled_time'])
          : null,
      signature: json['signature'],
      isSignatureImage: json['is_signature_image'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'body': body,
      'sender_name': senderName,
      'sender_email': senderEmail,
      'recipient_emails': recipientEmails,
      'cc_emails': ccEmails,
      'bcc_emails': bccEmails,
      'date': date.toIso8601String(),
      'attachments': attachments?.map((x) => x.toJson()).toList(),
      'is_read': isRead,
      'is_starred': isStarred,
      'is_draft': isDraft,
      'is_sent': isSent,
      'scheduled_time': scheduledTime?.toIso8601String(),
      'signature': signature,
      'is_signature_image': isSignatureImage,
    };
  }

  EmailModel copyWith({
    String? id,
    String? subject,
    String? body,
    String? senderName,
    String? senderEmail,
    List<String>? recipientEmails,
    List<String>? ccEmails,
    List<String>? bccEmails,
    DateTime? date,
    List<AttachmentModel>? attachments,
    bool? isRead,
    bool? isStarred,
    bool? isDraft,
    bool? isSent,
    DateTime? scheduledTime,
    String? signature,
    bool? isSignatureImage,
  }) {
    return EmailModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      body: body ?? this.body,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      recipientEmails: recipientEmails ?? this.recipientEmails,
      ccEmails: ccEmails ?? this.ccEmails,
      bccEmails: bccEmails ?? this.bccEmails,
      date: date ?? this.date,
      attachments: attachments ?? this.attachments,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      isDraft: isDraft ?? this.isDraft,
      isSent: isSent ?? this.isSent,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      signature: signature ?? this.signature,
      isSignatureImage: isSignatureImage ?? this.isSignatureImage,
    );
  }
}

class AttachmentModel {
  final String id;
  final String name;
  final String type; // file extension or MIME type
  final String url;
  final int size; // in bytes

  AttachmentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.size,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
      size: json['size'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'size': size,
    };
  }
}

class SignatureModel {
  final String id;
  final String name;
  final String content; // Text content or image URL
  final bool isImage;

  SignatureModel({
    required this.id,
    required this.name,
    required this.content,
    required this.isImage,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      content: json['content'] ?? '',
      isImage: json['is_image'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'is_image': isImage,
    };
  }
}