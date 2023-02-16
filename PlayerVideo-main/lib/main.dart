import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/material.dart';
import 'sizeConfig.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: VideoApp(),
    );
  }
}

class VideoApp extends StatefulWidget {

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;
  bool isVisible =false;
  int i = 0;
  bool entered=false;
  @override
  void initState() {
 SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
    _controller = VideoPlayerController.network(
        'http://media.7starcloud.com:1935/erodekrishnatv/livestream/playlist.m3u8')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  Widget build(BuildContext context) {
    if(!entered&&_controller.value.isInitialized)
    {
      setState(() {
        entered=true;
        isVisible=true;
      });
    }
    SizeConfig().init(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          setState(() {
            i++;
            print(i);
            if (i % 2 == 0) {
              isVisible = true;
            } else {
              isVisible = false;
            }
            _controller.value.isPlaying
                ? _controller.pause()
                :  _controller.play();
          });
        },
        child: Scaffold(
          backgroundColor: Colors.black,
          // _controller.value.isInitialized
          // Center(child: CircularProgressIndicator(),),
          body: _controller.value.isInitialized?SizedBox(
              height: SizeConfig.safeBlockVertical * 100,
              width: SizeConfig.safeBlockHorizontal * 100,
              child: Stack(children: [
                SizedBox(
                  height: MediaQuery.of(context).orientation == Orientation.portrait?SizeConfig.safeBlockVertical * 45:SizeConfig.safeBlockVertical * 100,
                  width: SizeConfig.safeBlockHorizontal * 100,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
               _controller.value.isBuffering? const Visibility(
                 visible: true,
                 child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 5,
                  )),
               ):const Visibility(
                 visible: false,
                 child: Center(
                     child: CircularProgressIndicator(
                       color: Colors.white,
                       strokeWidth: 5,
                     )),
               )
              ])): const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 5,
            ),
          ),
          floatingActionButton: Center(
            child: Visibility(
              visible: isVisible,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    i++;
                    print(i);
                    if (i % 2 == 0) {
                      isVisible = true;
                    } else {
                      isVisible = false;
                    }
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  }
                  );},
                child: Visibility(
                  visible: isVisible,
                  child: Center(
                    child: Container(
                      height: 75,
                      width: 75,
                      child: Image.asset(
                        _controller.value.isPlaying
                            ? 'assets/pause.png'
                            : 'assets/play.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
