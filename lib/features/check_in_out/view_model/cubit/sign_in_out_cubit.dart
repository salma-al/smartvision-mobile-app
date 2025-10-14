// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/check_records_model.dart';

part 'sign_in_out_state.dart';

class SignInOutCubit extends Cubit<SignInOutState> {
  SignInOutCubit() : super(SignInOutInitial());

  static SignInOutCubit get(context) => BlocProvider.of(context);
  
  File? imageFile;
  List<CheckRecordsModel> checkRecords = [];
  String currentLocation = '';
  String startHour = '---', endHour = '---';
  bool checkLoading = false, availableCheck = true, isCheckedIn = true;
  Timer? timer;
  Duration elapsedDuration = Duration.zero;
  String companyAddress = '';
  double compLat = 0.0, compLong = 0.0;
  double currLat = 0.0, currLong = 0.0;

  String formatTime(String time) {
    // Parse the input time string
    if(time == '---') return '---';
    final parts = time.split(':');
    int hour = int.parse(parts[0]);

    // Determine AM/PM and adjust hour for 12-hour format
    final isPM = hour >= 12;
    hour = hour % 12 == 0 ? 12 : hour % 12;

    final period = isPM ? 'PM' : 'AM';
    return '$hour $period';
  }
  String getFormattedDate() {
    final now = DateTime.now();
    final day = now.day;
    final month = getMonthName(now.month);
    final suffix = getDaySuffix(day);
    
    return '$month $day$suffix';
  }
  String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return monthNames[month - 1];
  }
  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
  String calculateHours(String inTime, String outTime) {
    DateTime now = DateTime.now();
    List<String> timeInParts = inTime.split(':');
    int hourIn = int.parse(timeInParts[0]);
    int minuteIn = int.parse(timeInParts[1]);
    int secondIn = int.parse(timeInParts[2]);
    DateTime checkIn = DateTime(
      now.year,
      now.month,
      now.day,
      hourIn,
      minuteIn,
      secondIn,
    );
    List<String> timeOutParts = outTime.split(':');
    int hourOut = int.parse(timeOutParts[0]);
    int minuteOut = int.parse(timeOutParts[1]);
    int secondOut = int.parse(timeOutParts[2]);
    DateTime checkOut = DateTime(
      now.year,
      now.month,
      now.day,
      hourOut,
      minuteOut,
      secondOut,
    );

    // Calculate the difference
    Duration difference = checkOut.difference(checkIn);

    // Extract hours and minutes
    int hours = difference.inHours;
    int minutes = difference.inMinutes % 60;

    return '$hours hours $minutes minutes';
  }
  Future<void> getCurrentLocation(context) async {
    ///handle permission
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ToastWidget().showToast('Location services are disabled.', context);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ToastWidget().showToast('Location permissions are denied', context);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      ToastWidget().showToast('Location permissions are permanently denied, we cannot request permissions.', context);
      return;
    } 
    ///get location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentLocation = '${position.latitude}, ${position.longitude}';
    currLat = position.latitude;
    currLong = position.longitude;
  }
  String formatDuration() {
    int hours = elapsedDuration.inHours;
    int minutes = elapsedDuration.inMinutes.remainder(60);
    int seconds = elapsedDuration.inSeconds.remainder(60);
    
    // Format to ensure two digits for each time component
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    
    return '${twoDigits(hours)} : ${twoDigits(minutes)} : ${twoDigits(seconds)}';
  }
  startTimer(DateTime lastCheckIn) {
    stopTimer(); // Ensure the previous timer is stopped
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(lastCheckIn)) {
        elapsedDuration = now.difference(lastCheckIn);
      } else {
        elapsedDuration = Duration.zero;
      }
      emit(UpdateElapsedTime());
    });
  }
  stopTimer() {
    timer?.cancel();
    timer = null;
    elapsedDuration = Duration.zero;
  }
  getLastChecks(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    checkLoading = true;
    emit(CheckInOutLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.lastCheckInOut, body, context);
      if(data['message']['status'] == 'success') {
        String start = data['message']['data']['shift']['start_time'] ?? '---';
        String end = data['message']['data']['shift']['end_time'] ?? '---';
        companyAddress = data['message']['data']['company_details']['address'] ?? 'unavailable';
        String lat = data['message']['data']['company_details']['latitude'] ?? '';
        String long = data['message']['data']['company_details']['longitude'] ?? '';
        availableCheck = data['message']['data']['shift status'] ?? false;
        if(lat.isNotEmpty && long.isNotEmpty) {
          compLat = double.parse(lat);
          compLong = double.parse(long);
        }
        startHour = formatTime(start);
        endHour = formatTime(end);
        checkRecords = [];
        for(var check in data['message']['data']['checkins']) {
          checkRecords.add(CheckRecordsModel.fromJson(check));
        }
        if(checkRecords.isEmpty) {
          checkRecords.add(CheckRecordsModel(checkInTime: '---', checkOutTime: '---'));
        }
        isCheckedIn = checkRecords.isEmpty || checkRecords.last.checkInTime == '---' || checkRecords.last.checkOutTime != '---';
        if(!availableCheck) {
          stopTimer();
          ToastWidget().showToast('You are out of shift.', context);
        } else {
          if(checkRecords.isNotEmpty && checkRecords.last.checkInTime != '---' && checkRecords.last.checkOutTime == '---') {
            DateTime now = DateTime.now();
            List<String> timeParts = checkRecords.last.checkInTime.split(':');
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);
            int second = int.parse(timeParts[2]);

            // Create a DateTime for today with the parsed time
            DateTime lastCheckIn = DateTime(
              now.year,
              now.month,
              now.day,
              hour,
              minute,
              second,
            );
            startTimer(lastCheckIn);
          }else {
            stopTimer();
          }
        }
        checkLoading = false;
        emit(GetLastCheckSuccess());
      } else {
        ToastWidget().showToast(data['message']['message'], context);
        checkLoading = false;
        emit(GetLastCheckError());
      }
    }catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      checkLoading = false;
      emit(GetLastCheckError());
    }
  }
  launchMap(context) async {
    final String googleMapsUrl = 'https://www.google.com/maps?q=$compLat,$compLong';
    
    try {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      ToastWidget().showToast('Could not launch the map', context);
    }
  }
  double calculateDistance() => Geolocator.distanceBetween(compLat, compLong, currLat, currLong);
  Future<void> pickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      
      if (image != null) {
        imageFile = File(image.path);
        if(checkRecords.isEmpty || 
           checkRecords.last.checkInTime == '---' || 
           checkRecords.last.checkOutTime != '---') {
          await checkFunction(context, true);
        } else {
          await checkFunction(context, false);
        }
      }
    } catch (e) {
      ToastWidget().showToast('Failed to capture image', context);
    }
  }  
  void clearImage() {
    imageFile = null;
    emit(ImageCleared());
  }
  checkFunction(context, bool isCheckIn) async {
    checkLoading = true;
    emit(CheckInOutLoading());
    await getCurrentLocation(context);
    if(currLat == 0.0 || currLong == 0.0) {
      ToastWidget().showToast('Please enable your location permissions and try again', context);
      checkLoading = false;
      emit(CheckInOutError());
      return;
    }
    double distance = calculateDistance();
    final instance = DataHelper.instance;
    String action = isCheckIn ? 'check-in' : 'check-out';
    
    final body = {
      'action': action,
      'employee_id': instance.userId!,
      'lat': currLat.toString(),
      'long': currLong.toString(),
      'distance': distance.toString(),
    };
    try {
      if(imageFile != null) {
        final data = await HTTPHelper.uploadFiles(context, imageFile!, EndPoints.checkInOut, 'image', body);
        if(data['status'] == 200) {
          imageFile = null;
          ToastWidget().showToast(data['data']['message']['message'], context);
          checkLoading = false;
          emit(CheckInOutSuccess());
          if(data['data']['message']['status'] == 'success') await getLastChecks(context);
          return;
        }
        return;
      }
      final data = await HTTPHelper.httpPost(EndPoints.checkInOut, body, context);
      if (data['message']['status'] == 'success') {
        imageFile = null;
        ToastWidget().showToast(data['message']['message'], context);
        emit(CheckInOutSuccess());
        await getLastChecks(context);
      } else {
        ToastWidget().showToast(data['message']['message'], context);
        emit(CheckInOutError());
      }
      checkLoading = false;
    } catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      checkLoading = false;
      emit(CheckInOutError());
    }
  }
}