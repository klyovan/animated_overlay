import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List animations = [];
  List icons = [
    Icons.face,
    Icons.settings,
    Icons.search,
  ];
  OverlayEntry overlayEntry;
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    for (int i = 3; i > 0; i--) {
      animations.add(
        Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              curve: Interval(
                0.2 * i,
                1.0,
                curve: Curves.easeOutCubic,
              ),
              parent: animationController),
        ),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    animationController.removeListener(() {
      setState(() {});
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: _key,
        onPressed: showOverlay,
        child: Icon(Icons.menu),
      ),
    );
  }

  showOverlay() async {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    Offset offset = renderBox.localToGlobal(Offset.zero);

    OverlayState overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        bottom: renderBox.size.height + 21,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < animations.length; i++)
              ScaleTransition(
                scale: animations[i],
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(icons[i]),
                  mini: true,
                ),
              ),
          ],
        ),
      ),
    );

    animationController.addListener(() {
      overlayState.setState(() {});
    });
    animationController.forward();

    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(seconds: 1));
    animationController.reverse();
  }
}
