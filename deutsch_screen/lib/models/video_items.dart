import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoPlay;

  VideoItems({
    this.autoPlay,
    this.looping,
    @required this.videoPlayerController,
    Key key,
  }) : super(key: key);

  @override
  _VideoItemsState createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  ChewieController _chewieController;

  @override
  void initState() {
    
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        //aspectRatio: 5/ 10,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage),
          );
        });
  }
  @override
  void dispose() { 
    
    super.dispose();
    _chewieController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
