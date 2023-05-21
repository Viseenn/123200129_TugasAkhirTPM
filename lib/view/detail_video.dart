import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasakhirtpm_123200129/view/profile_page.dart';
import 'package:tugasakhirtpm_123200129/view/saran_kesan_page.dart';
import 'package:video_player/video_player.dart';
import 'login_page.dart';

class DetailVideo extends StatefulWidget {
  final String videoUrl;

  DetailVideo({required this.videoUrl});

  @override
  State<DetailVideo> createState() => _DetailVideoState(videoUrl);
}

class _DetailVideoState extends State<DetailVideo> {
  final String videoUrl;
  int _currentIndex = 0;
  _DetailVideoState(this.videoUrl);
  late VideoPlayerController playerController;
  late SharedPreferences data;

  late DateTime today = DateTime.now();
  String time = "WIB";
  late String timeZone;

  @override
  void dispose() {
    super.dispose();
    playerController.dispose();
  }

  void timer() {
    setState(() {
      today = _zonaWaktu(time);
    });
  }

  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.network(videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => playerController.play());
    Timer.periodic(Duration(seconds: 1), (Timer t) => timer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Tutorial"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          if (value == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SaranKesanPage()));
          } else {
            AlertDialog alert = AlertDialog(
              title: Text("Logout"),
              content: Container(
                child: Text("Apakah yakin ingin Logout?"),
              ),
              actions: [
                TextButton(
                    child: Text("Ya"),
                    onPressed: () {
                      data.setBool('login', true);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
                TextButton(
                    child: Text("Tidak"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
            showDialog(context: context, builder: (context) => alert);
          }
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.person_outline_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Saran & Kesan'),
            icon: Icon(Icons.textsms_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Logout'),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            playerController.value.isInitialized
                ? buildVideo()
                : Container(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 5, left: 50),
              child: Text(
                "Diakses pada: " +
                    DateFormat('EEEE, dd MMMM yyyy').format(today) +
                    " " +
                    DateFormat("HH:mm:ss").format(today),
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonZonaWaktu("WIB"),
                buttonZonaWaktu("WIT"),
                buttonZonaWaktu("WITA"),
                buttonZonaWaktu("London"),
              ],
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            playerController.value.isPlaying
                ? playerController.pause()
                : playerController.play();
          });
        },
        child: Icon(
          playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  DateTime _zonaWaktu(String zonaWaktu) {
    if (zonaWaktu == "WIB") {
      return DateTime.now().toUtc().add(Duration(hours: 7));
    } else if (zonaWaktu == "WIT") {
      return DateTime.now().toUtc().add(Duration(hours: 9));
    } else if (zonaWaktu == "WITA") {
      return DateTime.now().toUtc().add(Duration(hours: 8));
    } else if (zonaWaktu == "London") {
      return DateTime.now().toUtc();
    } else {
      return DateTime.now();
    }
  }

  Widget buttonZonaWaktu(String zonaWaktu) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          time = zonaWaktu;
        });
      },
      child: Text(zonaWaktu),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: 1.0 / 1.0,
        child: VideoPlayer(playerController),
      );

  Widget buildBasicOverlay() => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => playerController.value.isPlaying
            ? playerController.pause()
            : playerController.play(),
        child: Stack(
          children: <Widget>[
            buildPlay(),
            Positioned(bottom: 0, left: 0, right: 0, child: buildIndicator())
          ],
        ),
      );

  Widget buildIndicator() =>
      VideoProgressIndicator(playerController, allowScrubbing: true);

  Widget buildPlay() => playerController.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
}
