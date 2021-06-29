class User {
  int id;
  bool loggedIn;
  String name;
  String email;
  String role;
  String pic;
  Details details;
  List<History> history;

  User.fromJson(Map<String, dynamic> json) {
    try {
      this.id = json['id'];
      this.loggedIn = true;
      this.name = json['name'];
      this.email = json['email'];
      this.role = json['role'];
      this.pic = json['pic'];

      this.details = Details.fromJson(json['details']);
      this.history = getHistoryList(json['history'] ?? []);
    } catch (e) {
      print("USER");
      print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      'loggedIn': this.loggedIn,
      'name': this.name,
      'email': this.email,
      'role': this.role,
      'pic': this.pic,
      'details': this.details.toJson(),
      'history': this.jsonHistory(this.history)
    };
  }

  void setName(String name) {
    this.name = name;
  }

  void setPic(String image) {
    this.pic = image;
  }

  List<History> getHistoryList(List<dynamic> historyList) {
    List<History> historyObj = historyList
        .map((dynamic history) =>
            History.fromJson(Map<String, dynamic>.from(history)))
        .toList();
    return historyObj;
  }

  List<Map<String, dynamic>> jsonHistory(List<History> history) {
    return history.map((History h) => h.toJson()).toList();
  }
}

class Details {
  int id;
  int userId;
  int parentId;
  int classId;
  String rollNumber;
  String gender;
  String phone;
  String dateofbirth;
  String currentAddress;
  String permanentAddress;
  String subscriptionDate;
  int isActive;
  String createdAt;
  String updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userId = json['user_id'];
      parentId = json['parent_id'];
      classId = json['class_id'];
      rollNumber = json['roll_number'];
      gender = json['gender'];
      phone = json['phone'];
      dateofbirth = json['dateofbirth'];
      currentAddress = json['current_address'];
      permanentAddress = json['permanent_address'];
      subscriptionDate = json['subscription_date'];
      isActive = json['is_active'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
    } catch (e) {
      print("USER DETAILS");
      print(e.toString());
    }
  }

  void setGender(String gender) {
    this.gender = gender;
  }

  void setDateOfBirth(String dob) {
    this.dateofbirth = dob;
  }

  void setPhone(String phone) {
    this.phone = phone;
  }

  void setCurrentAddress(String currentAddress) {
    this.currentAddress = currentAddress;
  }

  void setPermanentAddress(String permanentAddress) {
    this.permanentAddress = permanentAddress;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'user_id': this.userId,
      'parent_id': this.parentId,
      'class_id': this.classId,
      'roll_number': this.rollNumber,
      'gender': this.gender,
      'phone': this.phone,
      'dateofbirth': this.dateofbirth,
      'current_address': this.currentAddress,
      'permanent_address': this.permanentAddress,
      'subscription_date': this.subscriptionDate,
      'is_active': this.isActive,
      'created_at': this.createdAt,
      'updated_at': this.updatedAt
    };
  }
}

class History {
  int id;
  int userId;
  int classId;
  int termId;
  String amount;
  String className;
  String termName;
  String paymentId;
  String orderId;
  String createdAt;
  String updatedAt;

  History.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userId = json['user_id'];
      classId = json['class_id'];
      amount = json['amount'];
      termId = json['term_id'];
      className = json['class_name'];
      paymentId = json['payment_id'];
      orderId = json['order_id'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
    } catch (e) {
      print("History DETAILS");
      print(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'user_id': this.userId,
      'class_id': this.classId,
      'amount': this.amount,
      'term_id': this.termId,
      'class_name': this.className,
      'payment_id': this.paymentId,
      'order_id': this.orderId,
      'created_at': this.createdAt,
      'updated_at': this.updatedAt
    };
  }
}
