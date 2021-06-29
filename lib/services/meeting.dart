import 'package:act_class/models/meeting.dart';

import './index.dart';

class MeetingService {
  Services _service = Services();

  MeetingService();

  Future<List<Meeting>> getMeeting({int userId}) async {
    return await _service.getMeetings(userId);
  }

  Future<String> getMeetingUrl({int id, int meetingId}) async {
    return await _service.getMeetingUrl(id, meetingId);
  }
}
