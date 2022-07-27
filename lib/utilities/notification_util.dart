 import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationUtil {
  //  static Future<void> showNotificationImportance(
  //     int id, NotificationImportance importance) async {
  //   String importanceKey = importance.toString().toLowerCase().split('.').last;
  //   String channelKey = 'importance_' + importanceKey + '_channel';
  //   String title = 'Importance levels (' + importanceKey + ')';
  //   String body = 'Test of importance levels to ' + importanceKey;

  //   await AwesomeNotifications().setChannel(NotificationChannel(
  //       channelKey: channelKey,
  //       channelName: title,
  //       channelDescription: body,
  //       importance: importance,
  //       defaultColor: Colors.red,
  //       ledColor: Colors.red,
  //       vibrationPattern: highVibrationPattern));

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: id,
  //           channelKey: channelKey,
  //           title: title,
  //           body: body,
  //           payload: {'uuid': 'uuid-test'}));
  // }

//  Start.......................
  static Future<void> showIndeterminateProgressNotification(int id) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'progress_bar',
            title: 'Downloading fake file...',
            body: 'filename.txt',
            category: NotificationCategory.Progress,
            payload: {
              'file': 'filename.txt',
              'path': '-rmdir c://ruwindows/system32/huehuehue'
            },
            notificationLayout: NotificationLayout.ProgressBar,
            progress: null,
            locked: true));
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  static Future<void> showNotificationImportance(
    int id,
    NotificationImportance importance,
  ) async {
    String importanceKey = importance.toString().toLowerCase().split('.').last;
    String channelKey = 'importance_' + importanceKey + '_channel';
    String title = 'Importance levels (' + importanceKey + ')';
    String body = 'Test of importance levels to ' + importanceKey;

    await AwesomeNotifications().setChannel(NotificationChannel(
      channelKey: channelKey,
      channelName: title,
      channelDescription: body,
      importance: NotificationImportance.Default,
      defaultColor: Colors.blue,
      ledColor: Colors.blue,
      enableVibration: false,
      // vibrationPattern: highVibrationPattern
    ));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: channelKey,
            title: 'File Exported',
            body: 'Data Exported',
            payload: {'uuid': 'uuid-test'}));
  }
}
