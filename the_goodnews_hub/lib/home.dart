// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_goodnews_hub/videoplayer.dart';
import 'package:video_player/video_player.dart';

class myHomePage extends StatefulWidget {
  myHomePage({Key? key}) : super(key: key);

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  List _videoFile = [];
  List _videoDescription = [];
  List _videoTitle = [];

  final ScrollController _controller = ScrollController();
  int i = 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_videoFile);
    print(i);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          shadowColor: Colors.white,
          elevation: 20,
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
        body: _videoFile.isEmpty
            ? Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        readJson();
                      },
                      icon: Icon(Icons.refresh),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                    Text(
                      "Tap to view exclusive headline",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              )
            : ListView.builder(
                controller: _controller,
                itemCount: _videoFile.length,
                itemBuilder: (BuildContext context, int index) {
                  return videobox(index);
                },
              ),
        floatingActionButton:
            // FloatingActionButton(
            //   child: Icon(Icons.arrow_downward),
            //   onPressed: () => _animateToIndex(i),
            // ),
            GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
          ),
          onTap: () {
            _animateToIndex(i);
          },
        ));
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('resource/sampleVideo.json');
    final data = await json.decode(response);
    final exp = List.generate(
      data.length,
      (int index) => (data[index]["sources"]),
    );
    final exp1 = List.generate(
      data.length,
      (int index) => (data[index]["description"]),
    );
    final exp2 = List.generate(
      data.length,
      (int index) => (data[index]["title"]),
    );
    setState(() {
      _videoFile = exp;
      _videoDescription = exp1;
      _videoTitle = exp2;
    });
  }

  videobox(index) {
    return videoPlayer(
      _videoFile[index],
      _videoDescription[index],
      _videoTitle[index],
    );
  }

  void _animateToIndex(int ip) {
    _controller.animateTo(
      MediaQuery.of(context).size.height * (ip % _videoFile.length),
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
    setState(() {
      i = ip + 1;
    });
  }
}
