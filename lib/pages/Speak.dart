
import 'package:akitasummer_flutter_trip/plugin/asr_manager.dart';
import 'package:flutter/material.dart';

import 'Search.dart';

class Speak extends StatefulWidget {
  @override
  _SpeakState createState() => _SpeakState();
}

class _SpeakState extends State<Speak> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  String speakTips = '长按说话';
  String speakResult = '';

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 动画执行完后，重新执行
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topItem(),
              _bottomItem()
            ],
          ),
        )
      ),
    );
  }

  _topItem() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54
            ),
          ),
        ),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(speakResult, style: TextStyle(color: Colors.blue),),
        )
      ],
    );
  }

  _bottomItem() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: (e) {
              _speakStart();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakCancel();
            },
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(speakTips, style: TextStyle(color: Colors.blue, fontSize: 12),),
                  ),
                  Stack(
                    children: [
                      Container(
                        // 占位符，避免动画执行过程中大小改变影响布局
                        height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation: animation,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.grey
              ),
            )
          )
        ],
      ),
    );
  }

  _speakStart() {
    controller.forward();
    setState(() {
      speakTips = '- 识别中 -';
    });
    AsrManager.start().then((text) {
      if (text != null && text.length > 0) {
        setState(() {
          speakResult = text;
        });
        // 应先关闭页面再跳转，否则无法跳转
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Search(keyword: speakResult,)));
        print("-----$text");
      }
    }).catchError((e) {
      print("-----$e");
    });
  }

  _speakStop() {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }

  _speakCancel() {}
}

const double MIC_SIZE = 80;

class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(MIC_SIZE / 2),
        ),
        child: Icon(Icons.mic, color: Colors.white, size: 30),
      ),
    );
  }
}