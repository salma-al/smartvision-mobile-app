// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../model/check_records_model.dart';

part 'sign_in_out_state.dart';

class SignInOutCubit extends Cubit<SignInOutState> {
  SignInOutCubit() : super(SignInOutInitial());

  static SignInOutCubit get(context) => BlocProvider.of(context);
  
  File? imageFile;
  CheckModel? checkModel;
  String currentLocation = '';
  bool availableCheck = true, isCheckedIn = true;
  Timer? timer;
  Duration elapsedDuration = Duration.zero;
  double compLat = 0.0, compLong = 0.0;
  double currLat = 0.0, currLong = 0.0;
  double? uploadProgress;

  Duration getTotalWorked() {
    Duration totalWork = Duration.zero;
    DateTime current = DateTime.now();
    if(checkModel != null) {
      for(var check in checkModel!.records) {
        if(check.checkInTime != '---') {
          DateTime inTime = DateTime.parse('${current.year}-${current.month}-${current.day} ${check.checkInTime}');
          if(check.checkOutTime != '---') {
            DateTime outTime = DateTime.parse('${current.year}-${current.month}-${current.day} ${check.checkOutTime}');
            totalWork += outTime.difference(inTime);
          } else {
            totalWork += current.difference(inTime);
          }
        }
      }
    }
    return totalWork;
  }
  String formatDurationShort(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
  String formatTime(String time) {
    if(time == '---') return '---';
    final parts = time.split(':');
    int hour = int.parse(parts[0]);

    // Determine AM/PM and adjust hour for 12-hour format
    final isPM = hour >= 12;
    hour = hour % 12 == 0 ? 12 : hour % 12;

    final period = isPM ? 'PM' : 'AM';
    return '$hour $period';
  }
  String formatFullTime(String time) {
    if(time == '---') return '---';
    final parts = time.split(':');
    int hour = int.parse(parts[0]);

    // Determine AM/PM and adjust hour for 12-hour format
    final isPM = hour >= 12;
    hour = hour % 12 == 0 ? 12 : hour % 12;

    final period = isPM ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${parts[1].toString().padLeft(2, '0')} $period';
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
  void startTimer(DateTime lastCheckIn) {
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
  void stopTimer() {
    timer?.cancel();
    timer = null;
    elapsedDuration = Duration.zero;
  }
  Future<void> getLastChecks(BuildContext context) async {
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    emit(CheckInOutLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.lastCheckInOut, body, context);
      if(data['message']['status'] == 'success') {
        checkModel = CheckModel.fromJson(data['message']['data']);
        String lat = data['message']['data']['company_details']['latitude'] ?? '';
        String long = data['message']['data']['company_details']['longitude'] ?? '';
        if(lat.isNotEmpty && long.isNotEmpty) {
          compLat = double.parse(lat);
          compLong = double.parse(long);
        }
        if(checkModel != null && checkModel!.records.isEmpty) {
          checkModel!.records.add(CheckRecordsModel(checkInTime: '---', checkOutTime: '---'));
        }
        isCheckedIn = checkModel != null && (checkModel!.records.isEmpty || checkModel!.records.last.checkInTime == '---' || checkModel!.records.last.checkOutTime != '---');
        if(!availableCheck) {
          stopTimer();
          ToastWidget().showToast('You are out of shift.', context);
        } else {
          if(checkModel != null && checkModel!.records.isNotEmpty && checkModel!.records.last.checkInTime != '---' && checkModel!.records.last.checkOutTime == '---') {
            DateTime now = DateTime.now();
            List<String> timeParts = checkModel!.records.last.checkInTime.split(':');
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
        emit(GetLastCheckSuccess());
      } else {
        ToastWidget().showToast(data['message']['message'], context);
        emit(GetLastCheckError());
      }
    }catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      emit(GetLastCheckError());
    }
  }
  Future<void> launchMap(context) async {
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
        if(checkModel != null && (checkModel!.records.isEmpty || 
           checkModel!.records.last.checkInTime == '---' || 
           checkModel!.records.last.checkOutTime != '---')) {
          await checkFunction(context, true);
        } else {
          await checkFunction(context, false);
        }
      }
    } catch (e) {
      ToastWidget().showToast('Failed to capture image', context);
    }
  }  
  Future<void> checkFunction(context, bool isCheckIn) async {
    if(!isCheckIn) stopTimer();
    emit(CheckInOutLoading());
    await getCurrentLocation(context);
    if(currLat == 0.0 || currLong == 0.0) {
      ToastWidget().showToast('Please enable your location permissions and try again', context);
      emit(CheckInOutError());
      return;
    }
    double distance = calculateDistance();
    final instance = DataHelper.instance;
    final body = {
      'action': isCheckIn ? 'check-in' : 'check-out',
      'employee_id': instance.userId!,
      'lat': currLat.toString(),
      'long': currLong.toString(),
      'distance': distance.toString(),
    };
    try {
      if(imageFile != null) {
        final data = await HTTPHelper.uploadFilesWithProgress(
          context: context, 
          file: imageFile!, 
          endPoint: EndPoints.checkInOut, 
          imgKey: 'image', 
          body: body,
          onProgress: (progress) {
            uploadProgress = progress;
            emit(CheckInOutLoading());
          },
        );
        if(data['status'] == 200) {
          imageFile = null;
          ToastWidget().showToast(data['data']['message']['message'] ?? 'Attendance marked successfuly', context);
          uploadProgress = null;
          await getLastChecks(context);
        } else {
          ToastWidget().showToast(data['message']['message'] ?? 'Something went wrong', context);
          emit(CheckInOutError());
        }
        return;
      }
      final data = await HTTPHelper.httpPost(EndPoints.checkInOut, body, context);
      if (data['message']['status'] == 'success') {
        ToastWidget().showToast(data['message']['message'], context);
        await getLastChecks(context);
      } else {
        ToastWidget().showToast(data['message']['message'], context);
        emit(CheckInOutError());
      }
    } catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      emit(CheckInOutError());
    }
  }
}