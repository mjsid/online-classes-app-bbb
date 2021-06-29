import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/user.dart';
import '../models/meeting.dart';
import '../common/constants/apis.dart';

class Services {
  static final Services _instance = Services._internal();
  factory Services() => _instance;
  Services._internal();

  Future<Map<String, dynamic>> changePassword(
      {String oldPwd, String newPwd, int userId}) async {
    try {
      var response = await http.post(kPwdChangeApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode(
              {"id": userId, "password": newPwd, "old_password": oldPwd}));

      var jsonDecode = convert.jsonDecode(response.body);
      return Map<String, dynamic>.from(jsonDecode);
    } catch (e) {
      print("Change password");
      print(e.toString());
      rethrow;
    }
  }

  Future<bool> changeProfileDetails(Map<String, dynamic> json) async {
    try {
      var response = await http.post(kProfileChangeApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode(json));
      print("RESPONSE : ${response.body}");
      var jsonDecode = convert.jsonDecode(response.body);
      print("PRofile Response : $jsonDecode");
      return jsonDecode['success'];
    } catch (e) {
      print("Change profile");
      print(e.toString());
      rethrow;
    }
  }

  Future<User> login(String email, String password, String deviceToken) async {
    print("Inside Login");
    try {
      var response = await http.post(kLoginApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode({
            "email": email,
            "password": password,
            "device_token": deviceToken
          }));

      var jsonDecode = convert.jsonDecode(response.body);
      print("USER1: $jsonDecode");
      print("LOGIN HISTORY : ${jsonDecode['data']['history']}");
      return User.fromJson(jsonDecode['data']);
    } catch (e) {
      print("Inside login");
      print(e.toString());
      rethrow;
    }
  }

  Future<List<Meeting>> getMeetings(int userId) async {
    try {
      var response = await http.post(kMeetingApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode({"user_id": userId}));

      var jsonDecode = convert.jsonDecode(response.body);
      print("meetings: $jsonDecode");

      List<dynamic> data = jsonDecode['data'];
      List<Meeting> meetings = data
          .map((dynamic meeting) =>
              Meeting.fromjson(Map<String, dynamic>.from(meeting)))
          .toList();
      return meetings;
    } catch (e) {
      print("Inside getMeetings");
      print(e.toString());
      rethrow;
    }
  }

  Future<String> getMeetingUrl(int userId, int meetingId) async {
    try {
      var response = await http.post(kMeetingUrlApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body:
              convert.jsonEncode({"user_id": userId, "meeting_id": meetingId}));

      var jsonDecode = convert.jsonDecode(response.body);
      print("meetingURL: $jsonDecode");

      return jsonDecode['data'];
    } catch (e) {
      print("Inside getMeetingURL");
      print(e.toString());
      rethrow;
    }
  }

  Future<dynamic> registerUser(Map<String, dynamic> json) async {
    try {
      var response = await http.post(kRegisterApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode(json));

      var jsonDecode = convert.jsonDecode(response.body);
      print("Registered User: $jsonDecode");

      return jsonDecode;
    } catch (e) {
      print("Inside Register User");
      print(e.toString());
      rethrow;
    }
  }

  Future<dynamic> getSubscription(Map<String, dynamic> json) async {
    try {
      var response = await http.post(kSubscriptionApi,
          headers: {"Content-Type": "Application/json; charset=UTF-8"},
          body: convert.jsonEncode(json));

      var jsonDecode = convert.jsonDecode(response.body);
      print("Subscription Data: $jsonDecode");

      return jsonDecode;
    } catch (e) {
      print("Inside Subscription api");
      print(e.toString());
      rethrow;
    }
  }
}
