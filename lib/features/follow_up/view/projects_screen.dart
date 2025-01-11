import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/features/follow_up/view/follow_up_screen.dart';

import '../model/project_model.dart';

class ProjectsScreen extends StatelessWidget {
  final List<ProjectModel> projects = [
    ProjectModel(id: 1, currentProgress: 50, title: 'Project A', nextDate: DateTime.now().add(const Duration(days: 2))),
    ProjectModel(id: 2, currentProgress: 75, title: 'Project B', nextDate: null),
    ProjectModel(id: 3, currentProgress: 30, title: 'Project C', nextDate: DateTime.now().add(const Duration(days: 5))),
    ProjectModel(id: 4, currentProgress: 90, title: 'Project D', nextDate: null),
  ];

  ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Follow Up', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(context, project);
          },
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectModel project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DashedCircularProgressBar.aspectRatio(
              aspectRatio: 1,
              progress: project.currentProgress / 100,
              maxProgress: 1,
              corners: StrokeCap.round,
              foregroundStrokeWidth: 16,
              backgroundStrokeWidth: 16,
              foregroundColor: AppColors.mainColor,
              backgroundColor: Colors.grey.shade300,
              animation: true,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      project.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${project.currentProgress}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: project.nextDate == null
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FollowUpScreen()))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                project.nextDate == null
                    ? 'Start Follow-Up'
                    : 'Next: ${_formatDate(project.nextDate!)}',
                style: TextStyle(
                  fontSize: 14,
                  color: project.nextDate == null ? Colors.white : AppColors.darkColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}