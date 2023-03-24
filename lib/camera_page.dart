import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

import 'widgets/capture_button.dart';
import 'widgets/utils/file_utils.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  int _time = 0;
  Timer? _timer;

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          _time++;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  String toHoursMinutesSeconds(Duration duration) {
    String twoDigitMinutes = _toTwoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(duration.inSeconds.remainder(60));
    return "${_toTwoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photoAndVideo(
          photoPathBuilder: () => path(CaptureMode.photo),
          videoPathBuilder: () => path(CaptureMode.video),
          initialCaptureMode: CaptureMode.video,
        ),
        aspectRatio: CameraAspectRatios.ratio_16_9,
        previewFit: CameraPreviewFit.cover,
        flashMode: FlashMode.on,
        previewAlignment: Alignment.topRight,
        theme: AwesomeTheme(
          bottomActionsBackgroundColor: Colors.cyan.withOpacity(0.5),
          buttonTheme: AwesomeButtonTheme(
            backgroundColor: Colors.cyan.withOpacity(0.5),
            iconSize: 20,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            buttonBuilder: (child, onTap) {
              return ClipOval(
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    splashColor: Colors.cyan,
                    highlightColor: Colors.cyan.withOpacity(0.5),
                    onTap: onTap,
                    child: child,
                  ),
                ),
              );
            },
          ),
        ),
        topActionsBuilder: (state) => AwesomeTopActions(
          padding: EdgeInsets.zero,
          state: state,
          children: [
            Expanded(
              child: AwesomeFlashButton(
                state: state,
              ),
            ),
          ],
        ),
        middleContentBuilder: (state) {
          return Column(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: RotatedBox(
                    quarterTurns: 0,
                    child: StreamBuilder<MediaCapture?>(
                        stream: state.captureState$,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const SizedBox();
                          }

                          final isPaused =
                              snapshot.data!.videoState == VideoState.paused;

                          if (isPaused) {
                            _timer?.cancel();
                          } else {
                            _startTimer();
                          }

                          return Text(
                            toHoursMinutesSeconds(Duration(seconds: _time)),
                            style: const TextStyle(color: Colors.white),
                          );
                        }),
                  ),
                ),
              ),
              AwesomeCameraModeSelector(state: state)
            ],
          );
        },
        bottomActionsBuilder: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Center(
                    child: state is VideoRecordingCameraState
                        ? AwesomePauseResumeButton(
                            state: state,
                          )
                        : const SizedBox(),
                  ),
                ),
                CaptureButton(state: state),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
