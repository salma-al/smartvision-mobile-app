// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';

import '../../features/login/view/login_screen.dart';
import 'data_helper.dart';

class HTTPHelper {
  // Production (behind reverse proxy): 'https://erp.smartvgroup.com/api/method/svg_mobile_app.svg_apis.'
  static const String baseUrl = 'http://84.247.165.136:8003/api/method/svg_mobile_app.svg_apis.';
  static const String fileBaseUrl = 'http://84.247.165.136:8003';
  // static const String fileBaseUrl = 'https://erp.smartvgroup.com';
  static bool isRequestRunning = false;

  static Future login(String endPoint, dynamic body, BuildContext context, {Map<String, String>? headers}) async{
    Uri url = Uri.parse(baseUrl + endPoint);
    body = jsonEncode(body);
    headers = headers ?? <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response = await http.post(url, body: body, headers: headers);
    var utf8ResponseBody = utf8.decode(response.bodyBytes);
    return utf8ResponseBody;
  }

  static Future<void> forceLogout(BuildContext context) async {
    final instance = DataHelper.instance;
    String? email = CacheHelper.getData('email', String);
    String? pass = CacheHelper.getData('password', String);
    await instance.reset();
    await CacheHelper.setData('email', email);
    await CacheHelper.setData('password', pass);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
  
  static dynamic parseResponse(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {
        'status': 'fail',
        'message': body,
      };
    }
  }

  static Future<dynamic> httpPost(String endPoint, Map<String, dynamic> body, BuildContext context, {Map<String, String>? headers}) async {
    if(isRequestRunning) return null;
    isRequestRunning = true;
    Uri url = Uri.parse(baseUrl + endPoint);
    final instance = DataHelper.instance;
    if(instance.token == null) {
      await forceLogout(context);
      return null;
    }
    String encodedBody = jsonEncode(body);
    headers = headers ?? <String, String>{};
    headers['Content-Type'] = 'application/json';
    headers['Cookie'] = 'sid=${instance.token}';
    try {
      final response = await http.post(url, body: encodedBody, headers: headers);
      final utf8ResponseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 401 || utf8ResponseBody.contains('"session_expired":1')) {
        await forceLogout(context);
        return null;
      }
      return parseResponse(utf8ResponseBody);
    } catch (e) {
      return {'status': 'fail', 'message': 'Something went wrong'};
    } finally {
      isRequestRunning = false;
    }
  }

  static Future<dynamic> httpGet(String endPoint, BuildContext context, {Map<String, String>? headers}) async {
    if (isRequestRunning) return null;
    isRequestRunning = true;

    final instance = DataHelper.instance;
    if (instance.token == null) {
      await forceLogout(context);
      return;
    }
    Uri url = Uri.parse(baseUrl + endPoint);
    headers = headers ?? <String, String>{};
    headers['Content-Type'] = 'application/json';
    headers['Cookie'] = 'sid=${instance.token}';
    try {
      final response = await http.get(url, headers: headers);
      final utf8ResponseBody = utf8.decode(response.bodyBytes);
      if (response.statusCode == 401 || utf8ResponseBody.contains('"session_expired":1')) {
        await forceLogout(context);
        return;
      }
      return parseResponse(utf8ResponseBody);
    } catch (e) {
      return {'status': 'fail', 'message': 'Something went wrong'};
    } finally {
      isRequestRunning = false;
    }
  }

  static Future<Map<String, dynamic>> uploadFilesWithProgress({
    required BuildContext context,
    required File file,
    required String endPoint,
    required String imgKey,
    required Map<String, String> body,
    required Function(double progress) onProgress,
  }) async {
    if (isRequestRunning) {
      return {'status': 'fail', 'message': 'Can\'t run this request right now.'};
    }
    isRequestRunning = true;

    try {
      final uri = Uri.parse('$baseUrl$endPoint');
      final instance = DataHelper.instance;

      if (instance.token == null) {
        await instance.reset();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
        return {'status': 401, 'message': 'Token expired. Please log in again.'};
      }

      if (!await file.exists()) {
        return {'status': 400, 'message': 'The selected file does not exist.'};
      }

      final fileLength = await file.length();
      int bytesUploaded = 0;

      final stream = http.ByteStream(Stream.castFrom(file.openRead()));
      final Stream<List<int>> progressStream = stream.transform(
        StreamTransformer.fromHandlers(handleData: (data, sink) {
          bytesUploaded += data.length;
          final progress = bytesUploaded / fileLength;
          onProgress(progress.clamp(0.0, 1.0)); // 👈 steady progress 0 → 1
          sink.add(data);
        }),
      );

      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile(
        imgKey,
        progressStream,
        fileLength,
        filename: file.path.split('/').last,
        contentType: MediaType('image', 'png'),
      ));

      request.fields.addAll(body);
      request.headers.addAll({
        'Cookie': 'sid=${instance.token}',
      });

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      try {
        final decoded = jsonDecode(respStr);
        return {
          'status': response.statusCode,
          'data': decoded,
        };
      } catch (_) {
        return {
          'status': response.statusCode,
          'message': respStr,
        };
      }
    } catch (e) {
      return {'status': 500, 'message': 'Error: $e'};
    } finally {
      isRequestRunning = false;
    }
  }

  static Future<Map<String, dynamic>> uploadFiles(BuildContext context, File file, String endPoint, String imgKey, Map<String, String> body) async {
    if(isRequestRunning) return {'status': 'fail', 'message': 'Can\'t run this request right now.'};
    isRequestRunning = true;
    try {
      final uri = Uri.parse('$baseUrl$endPoint');
      final instance = DataHelper.instance;
      if(instance.token == null) {
        await instance.reset();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
        return {'status': 401, 'message': 'Token has expired. Please log in again.'};
      }
      var request = http.MultipartRequest('POST', uri);
      if (!await file.exists()) {
        return {'status': 400, 'message': 'The selected file does not exist.'};
      }
      final fileBytes = file.readAsBytesSync();
      request.files.add(
        http.MultipartFile.fromBytes(
          imgKey,
          fileBytes,
          filename: file.path.split('/').last,
          contentType: MediaType('image', 'png'),
        ),
      );
      request.fields.addAll(body);
      request.headers.addAll({
        // 'Content-Type': 'application/json',
        'Cookie': 'sid=${instance.token}',
      });
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      try {
        final decoded = jsonDecode(respStr);
        return {
          'status': response.statusCode,
          'data': decoded,
        };
      } catch (_) {
        return {
          'status': response.statusCode,
          'message': respStr,
        };
      }
    } catch (e) {
      return {'status': 500, 'message': 'An error occurred: $e'};
    } finally {
      isRequestRunning = false;
    }
  }
}
