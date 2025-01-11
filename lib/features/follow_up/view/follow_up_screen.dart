import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  FollowUpScreenState createState() => FollowUpScreenState();
}

class FollowUpScreenState extends State<FollowUpScreen> {
  String selectedProject = 'Project A';
  double completionPercentage = 0.0;
  final TextEditingController notesController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#497B7B'),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Follow Up', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: HexColor('#497B7B'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            
            // Completion Slider with External Label
            Text(
              'Completion Percentage',
              style: TextStyle(fontFamily: 'Colfax', fontSize: 16, color: HexColor('#FFF8DB')),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${completionPercentage.round()}%',
                  style: TextStyle(
                    fontFamily: 'Colfax',
                    fontSize: 16,
                    color: HexColor('#FFF8DB'),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: completionPercentage,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    activeColor: HexColor('#FFF8DB'),
                    inactiveColor: HexColor('#FFF8DB').withOpacity(0.5),
                    onChanged: (value) {
                      setState(() {
                        completionPercentage = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Notes Field
            Text(
              'Notes',
              style: TextStyle(fontFamily: 'Colfax', fontSize: 16, color: HexColor('#FFF8DB')),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: HexColor('#FFF8DB').withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter notes here...',
                  hintStyle: TextStyle(fontFamily: 'Colfax', color: HexColor('#1F3233').withOpacity(0.6)),
                ),
                style: TextStyle(fontFamily: 'Colfax', color: HexColor('#1F3233')),
              ),
            ),
            const SizedBox(height: 50),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#FFF8DB').withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: HexColor('#1F3233')),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
