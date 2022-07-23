import 'package:flutter/material.dart';
import 'package:goku_anim/animated_sprite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Size _screenSize = const Size(0.0, 0.0);
  double _frameHeight = 0.0;
  double _frameWidth = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationController.forward();
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _initFrameValues();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: _frameHeight,
        width: _frameWidth,
        child: AnimatedSprite(
            image: AssetImage('images/goku.png'),
            frameWidth: 50,
            frameHeight: 92,
            animation: Tween(begin: 0.0, end: 11.0).animate(CurvedAnimation(
                curve: const Interval(0, 1), parent: _animationController))),
      ),
    );
  }

  void _initFrameValues() {
    double screenRatio = _screenSize.height / _screenSize.width;
    double frameRatio = screenRatio < 2 ? screenRatio / 2 : .95;
    _frameWidth = _screenSize.width * frameRatio;
    _frameHeight = (92 * _frameWidth) / 50;
  }
}
