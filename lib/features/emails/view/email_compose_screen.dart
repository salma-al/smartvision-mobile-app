// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/custom_text_form_feild.dart';
import '../../../core/widgets/loading_widget.dart';
import '../model/email_model.dart';
import '../view_model/cubit/emails_cubit.dart';

class EmailComposeScreen extends StatefulWidget {
  final EmailModel? replyTo;
  final bool isReplyAll;
  final EmailModel? forwardFrom;
  final EmailModel? draft;

  const EmailComposeScreen({
    super.key,
    this.replyTo,
    this.isReplyAll = false,
    this.forwardFrom,
    this.draft,
  });

  @override
  State<EmailComposeScreen> createState() => _ComposeEmailScreenState();
}

class _ComposeEmailScreenState extends State<EmailComposeScreen> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _bccController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  
  bool _showCc = false;
  bool _showBcc = false;
  DateTime? _scheduledTime;
  List<AttachmentModel> _attachments = [];
  SignatureModel? _selectedSignature;
  late EmailCubit emailCubit;
  
  @override
  void initState() {
    super.initState();
    // We'll initialize the cubit in didChangeDependencies
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the cubit after the widget is fully built
    _initializeEmailData();
  }
  
  void _initializeEmailData() {
    // Handle reply
    if (widget.replyTo != null) {
      _subjectController.text = widget.replyTo!.subject.startsWith('Re:') 
          ? widget.replyTo!.subject 
          : 'Re: ${widget.replyTo!.subject}';
      _toController.text = widget.replyTo!.senderEmail;
      
      if (widget.isReplyAll) {
        // Add all recipients except current user
        final List<String> recipients = widget.replyTo!.recipientEmails
            .where((email) => email != 'current.user@example.com')
            .toList();
        
        if (recipients.isNotEmpty) {
          if (_toController.text.isNotEmpty) {
            _toController.text += ', ';
          }
          _toController.text += recipients.join(', ');
        }
        
        // Add CC recipients
        if (widget.replyTo!.ccEmails != null && widget.replyTo!.ccEmails!.isNotEmpty) {
          _showCc = true;
          _ccController.text = widget.replyTo!.ccEmails!
              .where((email) => email != 'current.user@example.com')
              .join(', ');
        }
      }
      
      // Add quoted text
      _bodyController.text = '\n\nOn ${DateFormat('yyyy-MM-dd HH:mm').format(widget.replyTo!.date)}, ${widget.replyTo!.senderName} <${widget.replyTo!.senderEmail}> wrote:\n> ${widget.replyTo!.body.replaceAll('\n', '\n> ')}';
    }
    
    // Handle forward
    else if (widget.forwardFrom != null) {
      _subjectController.text = widget.forwardFrom!.subject.startsWith('Fwd:') 
          ? widget.forwardFrom!.subject 
          : 'Fwd: ${widget.forwardFrom!.subject}';
      
      // Add forwarded message header
      _bodyController.text = '\n\n---------- Forwarded message ----------\n'
          'From: ${widget.forwardFrom!.senderName} <${widget.forwardFrom!.senderEmail}>\n'
          'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.forwardFrom!.date)}\n'
          'Subject: ${widget.forwardFrom!.subject}\n'
          'To: ${widget.forwardFrom!.recipientEmails.join(', ')}\n\n'
          '${widget.forwardFrom!.body}';
      
      // Add attachments if any
      if (widget.forwardFrom!.attachments != null) {
        _attachments = List.from(widget.forwardFrom!.attachments!);
      }
    }
    
    // Handle draft
    else if (widget.draft != null) {
      _toController.text = widget.draft!.recipientEmails.join(', ');
      _subjectController.text = widget.draft!.subject;
      _bodyController.text = widget.draft!.body;
      
      if (widget.draft!.ccEmails != null && widget.draft!.ccEmails!.isNotEmpty) {
        _showCc = true;
        _ccController.text = widget.draft!.ccEmails!.join(', ');
      }
      
      if (widget.draft!.bccEmails != null && widget.draft!.bccEmails!.isNotEmpty) {
        _showBcc = true;
        _bccController.text = widget.draft!.bccEmails!.join(', ');
      }
      
      if (widget.draft!.attachments != null) {
        _attachments = List.from(widget.draft!.attachments!);
      }
      
      _scheduledTime = widget.draft!.scheduledTime;
    }
  }
  
  void _loadSignatures(EmailCubit cubit) {
    // Load signatures from cubit
    if (cubit.signatures.isEmpty) {
      cubit.getSignatures(context);
    }
  }
  
  @override
  void dispose() {
    _toController.dispose();
    _ccController.dispose();
    _bccController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
  
  Future<void> _selectScheduleTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (pickedTime != null) {
        setState(() {
          _scheduledTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
  
  void _addAttachment() {
    // In a real app, this would open a file picker
    // For now, we'll add a dummy attachment
    setState(() {
      _attachments.add(AttachmentModel(
        id: 'A${_attachments.length + 1}',
        name: 'Document_${_attachments.length + 1}.pdf',
        type: 'pdf',
        url: 'https://example.com/files/document.pdf',
        size: 1500000, // 1.5 MB
      ));
    });
  }
  
  // void _selectSignature(EmailCubit cubit) {
  //   if (cubit.signatures.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('No signatures available')),
  //     );
  //     return;
  //   }
    
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) => ListView(
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.all(16),
  //       children: [
  //         const Text(
  //           'Select Signature',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //           textAlign: TextAlign.center,
  //         ),
  //         const SizedBox(height: 16),
  //         ...cubit.signatures.map((signature) => ListTile(
  //           title: Text(signature.name),
  //           subtitle: Text(
  //             signature.isImage ? 'Image Signature' : signature.content,
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //           onTap: () {
  //             setState(() {
  //               _selectedSignature = signature;
  //             });
  //             Navigator.pop(context);
  //           },
  //         )),
  //         ListTile(
  //           title: const Text('No Signature'),
  //           onTap: () {
  //             setState(() {
  //               _selectedSignature = null;
  //             });
  //             Navigator.pop(context);
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  
  void _sendEmail(EmailCubit cubit) {
    // Validate inputs
    if (_toController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one recipient')),
      );
      return;
    }
    
    // Parse recipients
    final List<String> recipients = _toController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    
    List<String>? ccList;
    if (_showCc && _ccController.text.isNotEmpty) {
      ccList = _ccController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    
    List<String>? bccList;
    if (_showBcc && _bccController.text.isNotEmpty) {
      bccList = _bccController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }
    
    // Create email model
    final EmailModel email = EmailModel(
      id: widget.draft?.id ?? '',
      subject: _subjectController.text.isEmpty ? '(No subject)' : _subjectController.text,
      body: _bodyController.text,
      senderName: 'Me', // In a real app, this would be the current user's name
      senderEmail: 'current.user@example.com', // In a real app, this would be the current user's email
      recipientEmails: recipients,
      ccEmails: ccList,
      bccEmails: bccList,
      date: DateTime.now(),
      attachments: _attachments.isEmpty ? null : _attachments,
      isRead: true,
      isStarred: false,
      isDraft: false,
      isSent: true,
      scheduledTime: _scheduledTime,
      signature: _selectedSignature?.content,
      isSignatureImage: _selectedSignature?.isImage ?? false,
    );
    
    // Send email using cubit
    cubit.sendEmail(
      context, 
      email, 
      isDraft: false,
      isScheduled: _scheduledTime != null,
    );
    
    // Navigate back
    Navigator.pop(context);
  }
  
  void _saveDraft(EmailCubit cubit) {
    // Create email model
    final EmailModel email = EmailModel(
      id: widget.draft?.id ?? '',
      subject: _subjectController.text.isEmpty ? '(No subject)' : _subjectController.text,
      body: _bodyController.text,
      senderName: 'Me', // In a real app, this would be the current user's name
      senderEmail: 'current.user@example.com', // In a real app, this would be the current user's email
      recipientEmails: _toController.text.isEmpty 
          ? [] 
          : _toController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      ccEmails: !_showCc || _ccController.text.isEmpty 
          ? null 
          : _ccController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      bccEmails: !_showBcc || _bccController.text.isEmpty 
          ? null 
          : _bccController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      date: DateTime.now(),
      attachments: _attachments.isEmpty ? null : _attachments,
      isRead: true,
      isStarred: false,
      isDraft: true,
      isSent: false,
      scheduledTime: _scheduledTime,
      signature: _selectedSignature?.content,
      isSignatureImage: _selectedSignature?.isImage ?? false,
    );
    
    // Save draft using cubit
    cubit.sendEmail(context, email, isDraft: true);
    
    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = EmailCubit();
        cubit.getEmails(context);
        _loadSignatures(cubit);
        return cubit;
      },
      child: BlocConsumer<EmailCubit, EmailState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          final emailCubit = context.read<EmailCubit>();
          
          return Scaffold(
            appBar: AppBar(
              title: const Text('Compose Email'),
              backgroundColor: AppColors.mainColor,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.attachment),
                  onPressed: _addAttachment,
                  tooltip: 'Add Attachment',
                ),
                IconButton(
                  icon: const Icon(Icons.schedule),
                  onPressed: _selectScheduleTime,
                  tooltip: 'Schedule Send',
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _saveDraft(emailCubit),
                  tooltip: 'Save Draft',
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendEmail(emailCubit),
                  tooltip: 'Send',
                ),
              ],
            ),
            body: emailCubit.loading
                ? const Center(child: LoadingWidget())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipients (To)
                        Row(
                          children: [
                            SizedBox(width: 40, child: Text('To:', style: TextStyle(color: AppColors.darkColor))),
                            Expanded(
                              child: CustomTextFormField(
                                controller: _toController,
                                hintText: 'Recipients',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                            ),
                            IconButton(
                              icon: Icon(_showCc ? Icons.expand_less : Icons.expand_more),
                              onPressed: () {
                                setState(() {
                                  if (!_showCc && !_showBcc) {
                                    _showCc = true;
                                  } else if (_showCc && !_showBcc) {
                                    _showBcc = true;
                                  } else {
                                    _showCc = false;
                                    _showBcc = false;
                                  }
                                });
                              },
                              tooltip: 'Show CC/BCC',
                            ),
                          ],
                        ),
                        
                        // Rest of the UI remains the same
                        // ...
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}