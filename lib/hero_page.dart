import 'package:flutter/material.dart';
import 'package:test_camera_awesome/widgets/player.dart';

import 'widgets/pod_player.dart';

enum PlayerType {
  videoPlayer,
  podPlayer,
}

class HeroPage extends StatelessWidget {
  final String path;
  final PlayerType type;
  const HeroPage({
    super.key,
    required this.path,
    this.type = PlayerType.podPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: path,
          child: type == PlayerType.podPlayer
              ? PodPlayer(path: path)
              : Player(path: path),
        ),
      ),
    );
  }
}
