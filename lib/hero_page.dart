import 'package:flutter/material.dart';
import 'package:test_camera_awesome/widgets/player.dart';

class HeroPage extends StatelessWidget {
  final String path;
  const HeroPage({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Hero(
          tag: path,
          child: Player(path: path),
        ),
      ),
    );
  }
}
