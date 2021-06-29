import 'package:act_class/services/index.dart';

class Meeting {
  int id;
  String title;
  String description;
  String classId;
  String className;
  String teacherName;
  String subjectName;
  String date;
  String startTime;
  String endTime;
  int userId;
  int teacherId;
  String url;
  String meetingId;
  String attendeePw;
  String moderatorPw;
  String createdAt;
  String updatedAt;
  bool isEnable;

  Meeting.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    classId = json['class_id'];
    className = json['class_name'];
    teacherName = json['teacher'] == null ? '' : json['teacher']['name'];
    subjectName = json['subject'] == null ? '' : json['subject']['name'];
    date = json['date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    userId = json['user_id'];
    teacherId = json['teacher_id'];
    url = json['url'];
    meetingId = json['meetingid'];
    attendeePw = json['attendeepw'];
    moderatorPw = json['moderatorPW'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": 6,
      "title": title,
      "description": description,
      "class_id": classId,
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "user_id": userId,
      "teacher_id": teacherId,
      "url": url,
      "meetingid": meetingId,
      "attendeepw": attendeePw,
      "moderatorPW": moderatorPw,
      "created_at": createdAt,
      "updated_at": updatedAt
    };
  }
}
