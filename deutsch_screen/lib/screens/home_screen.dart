import 'package:deutsch_screen/models/subtitles.dart';
import 'package:deutsch_screen/models/video_items.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Random random = new Random();
  int number = 2;

  void change() {
    setState(() {
      number = random.nextInt(subtitles.length);
      print("************* $number **************");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("descreen"),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              child: FutureBuilder(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      child: snapshot.data,
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                    ));
                  }
                  return Container();
                },
                future: _getVideo(context, '$number.mp4'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 8,
              child: Card(
                elevation: 10,
                color: Colors.blueGrey,
                child: FlipCard(
                  front: Center(
                      child: Text(
                    "Türkçe",
                    style: TextStyle(fontSize: 25),
                  )),
                  back: Center(
                      child: Text(
                    subtitles[number],
                    style: TextStyle(fontSize: 25),
                  )),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 8,
              child: Card(
                elevation: 10,
                color: Colors.blueGrey,
                child: FlipCard(
                  front: Center(
                      child: Text(
                    "Almanca",
                    style: TextStyle(fontSize: 25),
                  )),
                  back: Center(
                      child: Text(
                    "Almanca Çeviri",
                    style: TextStyle(fontSize: 25),
                  )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_next),
                  onPressed: change,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<Widget> _getVideo(BuildContext context, String videoName) async {
  VideoPlayerController videoPlayerController;
  await FireStorageService.loadVideo(context, videoName).then((value) {
    videoPlayerController = VideoPlayerController.network(
      value.toString(),
    );
  });
  return VideoItems(
    videoPlayerController: videoPlayerController,
    autoPlay: false,
    looping: false,
  );
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadVideo(BuildContext context, String video) async {
    return await FirebaseStorage.instance.ref().child(video).getDownloadURL();
  }
}
