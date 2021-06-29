import './index.dart';

class RegistrationService {
  Services _service = Services();

  RegistrationService();

  Future<dynamic> registerUser({Map<String, dynamic> user}) async {
    return await _service.registerUser(user);
  }

  Future<Map<String, dynamic>> changePassword(
      {String oldPwd, String newPwd, int userId}) async {
    return await _service.changePassword(
        oldPwd: oldPwd, newPwd: newPwd, userId: userId);
  }

  Future<bool> changeProfile(Map<String, dynamic> json) async {
    return await _service.changeProfileDetails(json);
  }

  Future<dynamic> getSubscription(Map<String, dynamic> json) async {
    return await _service.getSubscription(json);
  }
}
