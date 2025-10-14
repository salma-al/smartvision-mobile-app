import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/colors.dart';
import '../model/meeting_model.dart';

class MeetingDetailsScreen extends StatelessWidget {
  final MeetingModel meeting;

  const MeetingDetailsScreen({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Details'),
        backgroundColor: AppColors.mainColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              meeting.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Time and Date
            _buildInfoRow(
              Icons.access_time,
              meeting.isAllDay
                  ? 'All day'
                  : '${DateFormat('h:mm a').format(meeting.startTime)} - ${DateFormat('h:mm a').format(meeting.endTime)}',
            ),
            const SizedBox(height: 8),
            
            // Date
            _buildInfoRow(
              Icons.calendar_today,
              DateFormat('EEEE, MMMM d, yyyy').format(meeting.startTime),
            ),
            const SizedBox(height: 8),
            
            // Location
            _buildInfoRow(Icons.location_on, meeting.location),
            const SizedBox(height: 16),
            
            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(meeting.description),
            const SizedBox(height: 16),
            
            // Participants
            const Text(
              'Participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...meeting.participants.map((participant) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 8),
                  Text(participant),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.darkColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: AppColors.darkColor),
        ),
      ],
    );
  }
}