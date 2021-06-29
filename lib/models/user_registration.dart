import 'class.dart';

class UserRegistration {
  String name;
  String email;
  String password;
  String phone;
  String gender;
  String dateOfBirth;
  String currentAddress;
  String permanentAddress;
  int classId;
  Class classObj;
  GradeFee selectedPlan;

  UserRegistration(
      {this.name,
      this.email,
      this.password,
      this.phone,
      this.gender,
      this.dateOfBirth,
      this.currentAddress,
      this.permanentAddress,
      this.classId,
      this.selectedPlan = null});

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'phone': this.phone,
      'gender': this.gender,
      'dateofbirth': this.dateOfBirth,
      'current_address': this.currentAddress,
      'permanent_address': this.permanentAddress,
      'class_id': this.classId
    };
  }
}
