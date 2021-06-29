class Class {
  int id;
  int teacherId;
  int classNumeric;
  String className;
  String classDescription;
  String classPrice;
  String createdAt;
  String updatedAt;
  int studentsCount;
  List<GradeFee> gradeFees;

  Class.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teacherId = json['teacher_id'];
    classNumeric = json['class_numeric'];
    className = json['class_name'];
    classDescription = json['class_description'];
    classPrice = json['class_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    studentsCount = json['students_count'];
  }
}

class GradeFee {
  int id;
  int gradeId;
  int termId;
  String termName;
  int fees;
  String createdAt;
  String updatedAt;

  GradeFee.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gradeId = json['grade_id'];
    termId = json['term_id'];
    termName = json['term_name'];
    fees = json['fees'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}
