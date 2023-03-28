import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class PodPlayer extends StatefulWidget {
  final String path;
  const PodPlayer({
    super.key,
    required this.path,
  });

  @override
  State<PodPlayer> createState() => _PodPlayerState();
}

class _PodPlayerState extends State<PodPlayer> {
  late final PodPlayerController controller;

  @override
  void initState() {
    final playVideoFrom = PlayVideoFrom.file(File(widget.path));
    controller = PodPlayerController(playVideoFrom: playVideoFrom)
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(controller: controller);
  }
}
