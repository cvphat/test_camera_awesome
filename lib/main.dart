import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:flutter/material.dart';
import 'package:test_camera_awesome/camera_page.dart';

import 'hero_page.dart';
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
  List<Map<String, String>> videos = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.width * 9 / 16;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: videos
                  .map(
                    (e) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                      ),
                      child: InkWell(
                        child: Container(
                          height: height,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(
                                    2, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Image.file(
                            File(e['thumnailPath']!),
                          ),
                        ),
                        onDoubleTap: () {
                          setState(() {
                            videos.remove(e);
                          });
                        },
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ListView(
                              children: [
                                ListTile(
                                  onTap: () {
                                    OpenFile.open(e['videoPath']);
                                  },
                                  title: const Text('Default Player'),
                                  shape: const Border(bottom: BorderSide()),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HeroPage(
                                          path: e['videoPath']!,
                                          type: PlayerType.videoPlayer,
                                        ),
                                      ),
                                    );
                                  },
                                  title: const Text('Video Player'),
                                  shape: const Border(bottom: BorderSide()),
                                ),
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HeroPage(
                                          path: e['videoPath']!,
                                          type: PlayerType.podPlayer,
                                        ),
                                      ),
                                    );
                                  },
                                  title: const Text('Pod Player'),
                                  shape: const Border(bottom: BorderSide()),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
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
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CameraPage(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      videos.add(result);
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
