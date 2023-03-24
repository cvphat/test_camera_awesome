import 'package:flutter/material.dart';
import 'package:test_camera_awesome/camera_page.dart';

import 'widgets/player.dart';

void main() {
  runApp(const CameraApp());
}

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> videos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: videos
                  .map(
                    (e) => Player(path: e),
                  )
                  .toList(),
            ),
          ),
          const Divider(),
          SizedBox(
            height: 200,
            child: Center(
              child: ElevatedButton(
                child: const Text('Open Camera'),
                onPressed: () async {
                  final path = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraPage(),
                    ),
                  );
                  if (path != null) {
                    setState(() {
                      videos.add(path);
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
