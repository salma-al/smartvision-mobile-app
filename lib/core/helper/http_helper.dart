// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';

import '../../features/login/view/login_screen.dart';
import 'data_helper.dart';

class HTTPHelper {
  static const String baseUrl = 'http://84.247.165.136:8001/api/method/frappe.www.api.';
  static const String imgBaseUrl = 'http://84.247.165.136:8001';
  // static const String baseUrl = 'https://f739-41-234-86-182.ngrok-free.app/api/method/frappe.www.api.';

  static Future login(String endPoint, dynamic body, BuildContext context, {Map<String, String>? headers}) async{
    Uri url = Uri.parse(baseUrl + endPoint);
    body = jsonEncode(body);
    headers = headers ?? <String, String>{};
    headers['Content-Type'] = 'application/json';
    var response = await http.post(url, body: body, headers: headers);
    var utf8ResponseBody = utf8.decode(response.bodyBytes);
    return utf8ResponseBody;
  }

  static Future<dynamic> httpPost(String endPoint, Map<String, dynamic> body, BuildContext context, {Map<String, String>? headers}) async {
    Uri url = Uri.parse(baseUrl + endPoint);
    final instance = DataHelper.instance;

    // Ensure token is available; if not, reset and navigate to login
    if (instance.token == null) {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return;
    }

    // Encode body as JSON
    String encodedBody = jsonEncode(body);

    // Prepare headers
    headers = headers ?? <String, String>{};
    headers['Content-Type'] = 'application/json';
    headers['Cookie'] = 'sid=${instance.token}';

    try {
      // Make POST request
      final response = await http.post(url, body: encodedBody, headers: headers);

      // Decode response
      final utf8ResponseBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 401 || utf8ResponseBody.contains('"session_expired":1')) {
        await instance.reset();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
        return null;
      }

      // Parse and return JSON response
      return jsonDecode(utf8ResponseBody);
    } catch (e) {
      return {'status': 'fail', 'message': 'Something went wrong'};
    }
  }

  static Future httpGet(String endPoint, Map<String, String> headers, BuildContext context, {dynamic params}) async{
    Uri url = Uri.parse(baseUrl + endPoint).replace(queryParameters: params);
    final instance = DataHelper.instance;
    if(instance.token == null) {
      await instance.reset();
      await CacheHelper.setData('first_time', false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return;
    }
    if(instance.token != null && headers['Authorization'] == null) headers['Authorization'] = '${instance.token}';
    var response = await http.get(url, headers: headers);
    var body = response.body;
    if (body.contains('login')) {
      
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    var decodedResponse = jsonDecode(body);
    if (decodedResponse is Map<String, dynamic> && (decodedResponse['error'] == "Token has expired. Please log in again." || decodedResponse['message'] == 'Unauthenticated.')) {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    return response.body;
  }

  static Future httpPut(String endPoint, dynamic body, BuildContext context, {Map<String, String>? headers}) async{
    Uri url = Uri.parse(baseUrl + endPoint);
    final instance = DataHelper.instance;
    if(instance.token == null) {
      await instance.reset();
      await CacheHelper.setData('first_time', false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return;
    }
    headers = headers ?? <String, String>{};
    if(instance.token != null && (headers['Authorization'] == null)) headers['Authorization'] = '${instance.token}';
    var response = await http.put(url, body: body, headers: headers);
    var bodyy = response.body;
    if (bodyy.contains('login')) {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    var decodedResponse = jsonDecode(bodyy);
    if (decodedResponse is Map<String, dynamic> && decodedResponse['error'] == "Token has expired. Please log in again." || decodedResponse['message'] == 'Unauthenticated.') {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    return response.body;
  }

  static Future httpDelete(String endPoint, Map<String, String> headers, BuildContext context) async{
    Uri url = Uri.parse(baseUrl + endPoint);
    final instance = DataHelper.instance;
    if(instance.token == null) {
      await instance.reset();
      await CacheHelper.setData('first_time', false);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return;
    }
    if(instance.token != null && headers['Authorization'] == null) headers['Authorization'] = '${instance.token}';
    var response = await http.delete(url, headers: headers);
    var body = response.body;
    if (body.contains('login')) {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    Map<String, dynamic>? decodedResponse;
    try {
      decodedResponse = jsonDecode(body);
    } catch (e) {
      return body;
    }
    if (decodedResponse is Map<String, dynamic> && decodedResponse['error'] == "Token has expired. Please log in again." || decodedResponse!['message'] == 'Unauthenticated.') {
      await instance.reset();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
      return '';
    }
    return body;
  }

  static Future<void> uploadFiles(BuildContext context, File file, String url, String imgKey, Map<String, String> body) async {
    try {
      final uri = Uri.parse(url);
      final instance = DataHelper.instance;
      if(instance.token == null) {
        await instance.reset();
        await CacheHelper.setData('first_time', false);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
        return;
      }
      var request = http.MultipartRequest('POST', uri);
      if (await file.exists()) {
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
          'Content-Type': 'application/json',
          'Authorization': '${DataHelper.instance.token}',
        });
        var response = await request.send();
        String responseBody = await response.stream.bytesToString();
        if (responseBody.contains('login')) {
          await instance.reset();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
          return;
        }
        if (response.statusCode == 200) {
          if (responseBody[0] == '1') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text('Upload Successful'),
                  content: Text('The image has been uploaded successfully!'),
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Upload Failed'),
                  content: Text('Failed to upload the image. Reason: $responseBody'),
                );
              },
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Upload Failed'),
                content: Text('Server error: Unable to process the request.'),
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('File Not Found'),
              content: Text('The selected file does not exist.'),
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $e'),
          );
        },
      );
    }
  }
}