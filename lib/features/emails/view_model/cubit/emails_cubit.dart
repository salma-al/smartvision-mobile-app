// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/widgets/toast_widget.dart';
import '../../model/email_model.dart';

part 'emails_state.dart';

class EmailCubit extends Cubit<EmailState> {
  EmailCubit() : super(EmailInitial());

  static EmailCubit get(context) => BlocProvider.of(context);

  bool loading = false;
  List<EmailModel> emails = [], filteredEmails = [];
  List<SignatureModel> signatures = [];
  String? fromDate, toDate, fromDateValue, toDateValue, selectedEmailType;
  bool isFilterExpanded = false;
  bool showUnreadOnly = false;
  bool showStarredOnly = false;
  
  // For email details
  EmailModel? selectedEmail;

  // Get all emails
  void getEmails(BuildContext context) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would fetch emails from an API
      // For now, we'll use dummy data
      await Future.delayed(const Duration(milliseconds: 800));
      _loadDummyEmails();
      
      loading = false;
      emit(EmailsLoaded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to load emails', context);
      emit(EmailsLoaded());
    }
  }

  // Get signatures
  void getSignatures(BuildContext context) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would fetch signatures from an API or local storage
      await Future.delayed(const Duration(milliseconds: 500));
      _loadDummySignatures();
      
      loading = false;
      emit(EmailsLoaded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to load signatures', context);
      emit(EmailsLoaded());
    }
  }

  // Toggle star status
  void toggleStarred(BuildContext context, EmailModel email) async {
    try {
      // In a real app, you would update the star status via an API for non-local emails
      // For local emails (drafts and starred), just update locally
      
      // Find the email in the lists and update it
      final index = emails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        final updatedEmail = email.copyWith(isStarred: !email.isStarred);
        emails[index] = updatedEmail;
        
        // Also update in filtered list if present
        final filteredIndex = filteredEmails.indexWhere((e) => e.id == email.id);
        if (filteredIndex != -1) {
          filteredEmails[filteredIndex] = updatedEmail;
        }
        
        // Update selected email if it's the current one
        if (selectedEmail?.id == email.id) {
          selectedEmail = updatedEmail;
        }
        
        ToastWidget().showToast(
          updatedEmail.isStarred ? 'Email starred' : 'Email unstarred', 
          context
        );
        
        emit(EmailStarredUpdated());
      }
    } catch (e) {
      ToastWidget().showToast('Failed to update star status', context);
    }
  }

  // Mark as read/unread
  void toggleReadStatus(BuildContext context, EmailModel email) async {
    try {
      // In a real app, you would update the read status via an API
      
      // Find the email in the lists and update it
      final index = emails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        final updatedEmail = email.copyWith(isRead: !email.isRead);
        emails[index] = updatedEmail;
        
        // Also update in filtered list if present
        final filteredIndex = filteredEmails.indexWhere((e) => e.id == email.id);
        if (filteredIndex != -1) {
          filteredEmails[filteredIndex] = updatedEmail;
        }
        
        // Update selected email if it's the current one
        if (selectedEmail?.id == email.id) {
          selectedEmail = updatedEmail;
        }
        
        ToastWidget().showToast(
          updatedEmail.isRead ? 'Marked as read' : 'Marked as unread', 
          context
        );
        
        emit(EmailReadUpdated());
      }
    } catch (e) {
      ToastWidget().showToast('Failed to update read status', context);
    }
  }

  // Send email
  void sendEmail(BuildContext context, EmailModel email, {bool isDraft = false, bool isScheduled = false}) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would send the email via an API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Add to emails list
      final newEmail = email.copyWith(
        id: 'E${emails.length + 1}',
        date: DateTime.now(),
        isSent: !isDraft,
        isDraft: isDraft,
      );
      
      emails.add(newEmail);
      
      // Apply current filters to update filtered list
      _applyFilters();
      
      loading = false;
      
      if (isDraft) {
        ToastWidget().showToast('Email saved as draft', context);
        emit(EmailDrafted());
      } else if (isScheduled) {
        ToastWidget().showToast('Email scheduled for sending', context);
        emit(EmailSent());
      } else {
        ToastWidget().showToast('Email sent successfully', context);
        emit(EmailSent());
      }
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to send email', context);
      emit(EmailsLoaded());
    }
  }

  // Forward email
  void forwardEmail(BuildContext context, EmailModel originalEmail, List<String> recipients, 
      {List<String>? cc, List<String>? bcc, String? additionalText}) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would send the forwarded email via an API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Create forwarded email
      final forwardedEmail = EmailModel(
        id: 'E${emails.length + 1}',
        subject: 'Fwd: ${originalEmail.subject}',
        body: '${additionalText ?? ''}\n\n---------- Forwarded message ----------\nFrom: ${originalEmail.senderName} <${originalEmail.senderEmail}>\nDate: ${originalEmail.date.toString().substring(0, 16)}\nSubject: ${originalEmail.subject}\nTo: ${originalEmail.recipientEmails.join(', ')}\n\n${originalEmail.body}',
        senderName: 'Me', // In a real app, this would be the current user's name
        senderEmail: 'current.user@example.com', // In a real app, this would be the current user's email
        recipientEmails: recipients,
        ccEmails: cc,
        bccEmails: bcc,
        date: DateTime.now(),
        attachments: originalEmail.attachments,
        isRead: true,
        isStarred: false,
        isDraft: false,
        isSent: true,
      );
      
      emails.add(forwardedEmail);
      
      // Apply current filters to update filtered list
      _applyFilters();
      
      loading = false;
      ToastWidget().showToast('Email forwarded successfully', context);
      emit(EmailForwarded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to forward email', context);
      emit(EmailsLoaded());
    }
  }

  // Reply to email
  void replyEmail(BuildContext context, EmailModel originalEmail, String replyText, 
      {bool replyAll = false, List<String>? cc, List<String>? bcc}) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would send the reply via an API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Create reply recipients list
      List<String> recipients = [originalEmail.senderEmail];
      List<String>? replyCC = cc ?? [];
      
      // If reply all, add all original recipients except current user
      if (replyAll) {
        recipients.addAll(originalEmail.recipientEmails.where(
          (email) => email != 'current.user@example.com' // In a real app, check against current user
        ));
        
        // Add original CC recipients if any
        if (originalEmail.ccEmails != null) {
          replyCC.addAll(originalEmail.ccEmails!.where(
            (email) => email != 'current.user@example.com' // In a real app, check against current user
          ));
        }
      }
      
      // Create reply email
      final replyEmail = EmailModel(
        id: 'E${emails.length + 1}',
        subject: originalEmail.subject.startsWith('Re:') ? originalEmail.subject : 'Re: ${originalEmail.subject}',
        body: '$replyText\n\nOn ${originalEmail.date.toString().substring(0, 16)}, ${originalEmail.senderName} <${originalEmail.senderEmail}> wrote:\n> ${originalEmail.body.replaceAll('\n', '\n> ')}',
        senderName: 'Me', // In a real app, this would be the current user's name
        senderEmail: 'current.user@example.com', // In a real app, this would be the current user's email
        recipientEmails: recipients,
        ccEmails: replyCC.isEmpty ? null : replyCC,
        bccEmails: bcc,
        date: DateTime.now(),
        isRead: true,
        isStarred: false,
        isDraft: false,
        isSent: true,
      );
      
      emails.add(replyEmail);
      
      // Apply current filters to update filtered list
      _applyFilters();
      
      loading = false;
      ToastWidget().showToast('Reply sent successfully', context);
      emit(EmailReplied());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to send reply', context);
      emit(EmailsLoaded());
    }
  }

  // Download attachment
  Future<void> downloadAttachment(BuildContext context, AttachmentModel attachment) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would download the file from the URL
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // Simulate saving to downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${attachment.name}';
      
      // In a real app, you would actually download and save the file
      // For now, just simulate success
      
      loading = false;
      ToastWidget().showToast('Downloaded to $filePath', context);
      emit(AttachmentDownloaded());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to download attachment', context);
      emit(EmailsLoaded());
    }
  }

  // Update signature
  void updateSignature(BuildContext context, SignatureModel signature) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would save the signature to local storage or API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Find if signature already exists
      final index = signatures.indexWhere((s) => s.id == signature.id);
      if (index != -1) {
        signatures[index] = signature;
      } else {
        signatures.add(signature);
      }
      
      loading = false;
      ToastWidget().showToast('Signature updated successfully', context);
      emit(SignatureUpdated());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to update signature', context);
      emit(EmailsLoaded());
    }
  }

  // Delete email
  void deleteEmail(BuildContext context, EmailModel email) async {
    try {
      loading = true;
      emit(EmailLoading());
      
      // In a real app, you would delete the email via an API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Remove from lists
      emails.removeWhere((e) => e.id == email.id);
      filteredEmails.removeWhere((e) => e.id == email.id);
      
      loading = false;
      ToastWidget().showToast('Email deleted', context);
      emit(EmailDeleted());
    } catch (e) {
      loading = false;
      ToastWidget().showToast('Failed to delete email', context);
      emit(EmailsLoaded());
    }
  }

  // Select email for viewing details
  void selectEmail(EmailModel email) {
    selectedEmail = email;
    
    // If email is unread, mark it as read
    if (!email.isRead) {
      final index = emails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        final updatedEmail = email.copyWith(isRead: true);
        emails[index] = updatedEmail;
        selectedEmail = updatedEmail;
        
        // Also update in filtered list if present
        final filteredIndex = filteredEmails.indexWhere((e) => e.id == email.id);
        if (filteredIndex != -1) {
          filteredEmails[filteredIndex] = updatedEmail;
        }
      }
    }
    
    emit(EmailsLoaded());
  }

  // Toggle filter panel
  void toggleFilter() {
    isFilterExpanded = !isFilterExpanded;
    emit(EmailFilterToggled());
  }

  // Select date range
  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    
    if (pickedDate != null) {
      if (isFromDate) {
        fromDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
        fromDateValue = fromDate;
      } else {
        toDate = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
        toDateValue = toDate;
      }
      emit(EmailDateRangeChanged());
    }
  }

  // Change email type filter
  void changeEmailType(String? type) {
    selectedEmailType = type;
    emit(EmailTypeChanged());
  }

  // Toggle unread filter
  void toggleUnreadFilter() {
    showUnreadOnly = !showUnreadOnly;
    emit(EmailReadToggled());
  }

  // Toggle starred filter
  void toggleStarredFilter() {
    showStarredOnly = !showStarredOnly;
    emit(EmailStarredToggled());
  }

  // Apply all filters
  void applyFilters(BuildContext context) {
    _applyFilters();
    toggleFilter();
  }

  // Internal method to apply filters
  void _applyFilters() {
    filteredEmails = List.from(emails);
    
    // Filter by email type
    if (selectedEmailType != null && selectedEmailType != 'All') {
      if (selectedEmailType == 'Inbox') {
        filteredEmails = filteredEmails.where((email) => !email.isSent && !email.isDraft).toList();
      } else if (selectedEmailType == 'Sent') {
        filteredEmails = filteredEmails.where((email) => email.isSent).toList();
      } else if (selectedEmailType == 'Drafts') {
        filteredEmails = filteredEmails.where((email) => email.isDraft).toList();
      }
    }
    
    // Filter by unread
    if (showUnreadOnly) {
      filteredEmails = filteredEmails.where((email) => !email.isRead).toList();
    }
    
    // Filter by starred
    if (showStarredOnly) {
      filteredEmails = filteredEmails.where((email) => email.isStarred).toList();
    }
    
    // Filter by date range
    if (fromDateValue != null && toDateValue != null) {
      final fromDateTime = DateTime.parse(fromDateValue!);
      final toDateTime = DateTime.parse(toDateValue!).add(const Duration(days: 1));
      
      filteredEmails = filteredEmails.where((email) {
        return email.date.isAfter(fromDateTime) && email.date.isBefore(toDateTime);
      }).toList();
    }
    
    emit(EmailFiltered());
  }

  // Load dummy emails for testing
  void _loadDummyEmails() {
    emails = [
      EmailModel(
        id: 'E001',
        subject: 'Project Update - Q3 Goals',
        body: 'Hello team,\n\nI wanted to share an update on our Q3 goals and progress. We\'ve made significant strides in the mobile app development and are on track to meet our deadlines.\n\nPlease review the attached documents and let me know if you have any questions.\n\nBest regards,\nJohn',
        senderName: 'John Manager',
        senderEmail: 'john.manager@company.com',
        recipientEmails: ['team@company.com', 'you@company.com'],
        ccEmails: ['sarah@company.com'],
        date: DateTime.now().subtract(const Duration(days: 2)),
        attachments: [
          AttachmentModel(
            id: 'A001',
            name: 'Q3_Goals.pdf',
            type: 'pdf',
            url: 'https://example.com/files/Q3_Goals.pdf',
            size: 2500000, // 2.5 MB
          ),
          AttachmentModel(
            id: 'A002',
            name: 'Project_Timeline.xlsx',
            type: 'xlsx',
            url: 'https://example.com/files/Project_Timeline.xlsx',
            size: 1800000, // 1.8 MB
          ),
        ],
        isRead: false,
        isStarred: true,
        isDraft: false,
        isSent: false,
      ),
      EmailModel(
        id: 'E002',
        subject: 'Meeting Invitation: Design Review',
        body: 'Hi,\n\nYou\'re invited to a design review meeting on Friday at 2 PM. We\'ll be discussing the new UI components for the mobile app.\n\nPlease confirm your attendance.\n\nRegards,\nSarah',
        senderName: 'Sarah Designer',
        senderEmail: 'sarah.designer@company.com',
        recipientEmails: ['you@company.com'],
        date: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        isStarred: false,
        isDraft: false,
        isSent: false,
      ),
      EmailModel(
        id: 'E003',
        subject: 'Weekly Report - Development Team',
        body: 'Hello,\n\nAttached is the weekly report for the development team. We\'ve made progress on several key features and fixed 12 critical bugs.\n\nLet me know if you need any clarification.\n\nThanks,\nMike',
        senderName: 'Mike Developer',
        senderEmail: 'mike.dev@company.com',
        recipientEmails: ['team@company.com', 'you@company.com'],
        date: DateTime.now().subtract(const Duration(hours: 5)),
        attachments: [
          AttachmentModel(
            id: 'A003',
            name: 'Weekly_Report.pdf',
            type: 'pdf',
            url: 'https://example.com/files/Weekly_Report.pdf',
            size: 1200000, // 1.2 MB
          ),
        ],
        isRead: false,
        isStarred: false,
        isDraft: false,
        isSent: false,
      ),
      EmailModel(
        id: 'E004',
        subject: 'Draft: Client Proposal',
        body: 'Here\'s the draft proposal for the new client project. Need to add budget details and timeline before sending.',
        senderName: 'Me',
        senderEmail: 'you@company.com',
        recipientEmails: ['client@example.com'],
        date: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
        isStarred: false,
        isDraft: true,
        isSent: false,
      ),
      EmailModel(
        id: 'E005',
        subject: 'Re: Project Requirements',
        body: 'Thanks for the detailed requirements. Our team will review them and get back to you with questions if needed.\n\nBest regards,\nYou',
        senderName: 'Me',
        senderEmail: 'you@company.com',
        recipientEmails: ['client@example.com'],
        date: DateTime.now().subtract(const Duration(days: 4)),
        isRead: true,
        isStarred: false,
        isDraft: false,
        isSent: true,
      ),
    ];
    
    filteredEmails = List.from(emails);
  }

  // Load dummy signatures
  void _loadDummySignatures() {
    signatures = [
      SignatureModel(
        id: 'S001',
        name: 'Default',
        content: 'Best regards,\nYour Name\nPosition | Company\nPhone: +1 234 567 890',
        isImage: false,
      ),
      SignatureModel(
        id: 'S002',
        name: 'Formal',
        content: 'Sincerely,\nYour Full Name\nSenior Position\nCompany Name\nEmail: your.email@company.com\nPhone: +1 234 567 890',
        isImage: false,
      ),
    ];
  }
}