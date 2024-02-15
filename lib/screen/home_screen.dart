
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inflearn_cf_video_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: video == null  ? renderEmpty() : renderVideo(),
    );
  }
  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
          onNewVideoPressed: onNewVideoPressed,
          video: video!
      ),
    );
  }

  Widget renderEmpty(){
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(
            onTap: onNewVideoPressed,
          ),
          SizedBox(height: 10,),
          _getText(),
        ],
      ),
    );
  }
  void onNewVideoPressed() async{
    final video = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
    );
    if(video != null){
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration(){
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000119),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback onTap;
  const _Logo({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Image.asset('asset/image/logo.png'));
  }
}

class _getText extends StatelessWidget {
  const _getText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('VIDEO',style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),),
        Text('PLAYER',style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300),),
      ],
    );
  }
}

