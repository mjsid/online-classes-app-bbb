import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/index.dart';
import 'user.dart';
export 'user.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    // getUser();
  }

  User user;
  bool loggedIn = false;
  bool loading = false;
  final Services _service = Services();

  Future<void> logout() async {
    // user = null;
    loggedIn = false;
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        await storage.deleteItem("userInfo");
        await storage.setItem("userInfo", null);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', false);
      }
      // await _service.logout();
    } catch (err) {
      print("logOUT ERROR");
      print(err);
    }
    print("LOGOUT");
    notifyListeners();
  }

  void setUserName(String name) {
    user.setName(name);
    notifyListeners();
    saveUserNameLocally(name);
  }

  void setPhoneNumber(String phoneNumber) {
    user.details.setPhone(phoneNumber);
    notifyListeners();
    savePhoneNumberLocally(phoneNumber);
  }

  void setCurrentAddress(String currentAddress) {
    user.details.setCurrentAddress(currentAddress);
    notifyListeners();
    saveCurrentAddressLocally(currentAddress);
  }

  void setPermanentAddress(String permanentAddress) {
    user.details.setPermanentAddress(permanentAddress);
    notifyListeners();
    savePermanentAddressLocally(permanentAddress);
  }

  void setGender(String gender) {
    user.details.setGender(gender);
    notifyListeners();
    saveGenderLocally(gender);
  }

  void setDateOfBirth(String dateOfBirth) {
    user.details.setDateOfBirth(dateOfBirth);
    notifyListeners();
    saveDateOfBirthLocally(dateOfBirth);
  }

  void setImage(String image) {
    user.setPic(image);
    notifyListeners();
    saveImageLocally(image);
  }

  Future<void> userLogin(
      {String email,
      String password,
      String deviceToken,
      Function success,
      Function fail}) async {
    print("Inside userLogin");
    try {
      loading = true;
      // notifyListeners();
      user = await _service.login(email, password, deviceToken);
      loggedIn = true;

      await saveUser(user);
      print("User Saved");
      success(user);
      print("SUCCESS");
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      print("inside user_model userLogin method");
      print(e.toString());
      fail(e.toString());
      notifyListeners();
    }
  }

  Future<void> saveUser(User user) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      // save to Preference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);

      // save the user Info as local storage
      final ready = await storage.ready;
      if (ready) {
        print("Setting user to local db");
        Map<String, dynamic> json = user.toJson();
        print("Saved History : ${json['history']}");
        await storage.setItem("userInfo", json);
      }
    } catch (err) {
      print("saveUser error");
      print(err);
    }
  }

  Future<void> savePhoneNumberLocally(String phoneNumber) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['details']['phone'] = phoneNumber;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("savePhoneNumber error");
      print(err);
    }
  }

  Future<void> saveCurrentAddressLocally(String currentAddress) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['details']['current_address'] = currentAddress;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("saveCurrentAddress error");
      print(err);
    }
  }

  Future<void> savePermanentAddressLocally(String permanentAddress) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['details']['permanent_address'] = permanentAddress;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("savePermanentAddress error");
      print(err);
    }
  }

  Future<void> saveGenderLocally(String gender) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['details']['gender'] = gender;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("saveGender error");
      print(err);
    }
  }

  Future<void> saveDateOfBirthLocally(String dateOfBirth) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['details']['dateofbirth'] = dateOfBirth;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("saveDateOfBirthLocally error");
      print(err);
    }
  }

  Future<void> saveUserNameLocally(String name) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['name'] = name;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("saveUserName error");
      print(err);
    }
  }

  Future<void> saveImageLocally(String image) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;
      if (ready) {
        final json = storage.getItem("userInfo");
        if (json != null) {
          json['pic'] = image;
          await storage.setItem("userInfo", json);
        }
      }
    } catch (err) {
      print("saveImageLocally error");
      print(err);
    }
  }

  Future<void> saveTrasanctionId(String transactionId) async {
    final LocalStorage storage = LocalStorage("fstore");
    try {
      // save to Preference
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('loggedIn', true);

      // save the transaction Info as local storage
      final ready = await storage.ready;
      if (ready) {
        print("saving transaction id $transactionId");
        await storage.setItem("transactionId", transactionId);
      }
    } catch (err) {
      print("saveUser error");
      print(err);
    }
  }

  Future<User> getUser() async {
    print("get user details");
    final LocalStorage storage = LocalStorage("fstore");
    try {
      final ready = await storage.ready;

      if (ready) {
        final json = storage.getItem("userInfo");
        print("get USER : $json");
        if (json != null) {
          user = User.fromJson(json);
          this.loggedIn = true;
          notifyListeners();
        }
      }
    } catch (err) {
      print(err);
    }
    return user;
  }
}
