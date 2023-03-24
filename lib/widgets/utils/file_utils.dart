import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';

Future<String> path(CaptureMode captureMode) async {
  final String fileExtension = captureMode == CaptureMode.photo ? 'jpg' : 'mp4';
  final String filePath =
      '/sdcard/Android/data/test_camera_awesome/cache/${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
  return filePath;
}
