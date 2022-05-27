import 'package:flutter/material.dart';
import 'package:the_goodnews_hub/home.dart';
import 'package:video_player/video_player.dart';

class videoPlayer extends StatefulWidget {
  videoPlayer(this.url, this.description, this.title, {Key? key});

  final String url;
  final String title;
  final String description;
  @override
  State<videoPlayer> createState() => _videoPlayerState();
}

class _videoPlayerState extends State<videoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.url,
        videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false, allowBackgroundPlayback: false));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(1.0);
    // _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    print("dispose Sub  ${widget.key}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  decoration: TextDecoration.underline,
                ),
              ),
              FutureBuilder(
                key: widget.key,
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: VideoPlayer(
                                _controller,
                                key: widget.key,
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                )),
                            Align(
                              child: FloatingActionButton(
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  setState(() {
                                    if (_controller.value.isPlaying) {
                                      _controller.pause();
                                    } else {
                                      _controller.play();
                                    }
                                  });
                                },
                                child: _controller.value.isPlaying
                                    ? Container(
                                        color: Colors.transparent,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        size: 40,
                                      ),
                              ),
                            ),
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
              ),
              Text(
                "Description : " + widget.description,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
