// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class myHomePage extends StatefulWidget {
  myHomePage({Key? key}) : super(key: key);

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  List _items = [];
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('resource/sampleVideo.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["videos"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_items);
    // readJson();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.personal_video),
            SizedBox(
              width: 20,
            ),
            Title(color: Colors.white, child: Text("News Flash")),
          ],
        ),
      ),
      body: _items.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        readJson();
                      },
                      icon: Icon(Icons.refresh)),
                  Text("Tap to Refresh")
                ],
              ),
            )
          : ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return videobox(index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  videobox(index) {
    // return ListTile(
    //     leading: Text(_items[index]["title"]),
    //     title: Vcontroller != null
    //         ? Container(
    //             child: VideoPlayer(Vcontroller),
    //           )
    //         : Container(
    //             child: CircularProgressIndicator(),
    //           ));
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
