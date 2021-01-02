import 'package:flutter/material.dart';
import 'package:whatsapp_appbar/painter.dart';

class CustomScaffold extends StatefulWidget {
  final AppBar appBar;
  final Widget body;
  final FloatingActionButton floatingActionButton;

  CustomScaffold({
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  @override
  CustomScaffoldState createState() => CustomScaffoldState();
}

class CustomScaffoldState extends State<CustomScaffold>
    with TickerProviderStateMixin {
  AnimationController _controllerHeight;
  AnimationController _controllerRipple;
  Animation _animationHeight;
  Animation _animationRipple;
  bool _expanded = false;
  double rippleStartX = 0;
  double rippleStartY = 0;

  Tween<double> _tweenHeight = Tween(
    begin: 56,
    end: 100,
  )..chain(CurveTween(curve: Curves.elasticOut));

  Tween<double> _tweenRipple = Tween(
    begin: 0,
    end: 1,
  );

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        _expanded = true;
      });
    }
    if (animationStatus == AnimationStatus.reverse) {
      setState(() {
        _expanded = false;
      });
    }
  }

  @override
  void initState() {
    _controllerHeight =
        AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    _controllerRipple =
        AnimationController(vsync: this, duration: Duration(milliseconds: 180));
    _controllerRipple.addStatusListener(animationStatusListener);
    _animationHeight = _tweenHeight.animate(_controllerHeight)
      ..addListener(() {
        setState(() {});
      });
    _animationRipple = _tweenRipple.animate(_controllerRipple);
    super.initState();
  }

  @override
  void dispose() {
    _controllerHeight.dispose();
    _controllerRipple.dispose();
    super.dispose();
  }

  void onSearchTapUp(TapUpDetails details) {
    _controllerHeight.forward();
    _controllerRipple.forward();
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });
  }

  cancelSearch(TapUpDetails details) {
    _controllerHeight.reverse();
    _controllerRipple.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(_animationHeight.value),
              child: Stack(
                children: [
                  AppBar(
                    title: Text('Title'),
                    actions: [
                      GestureDetector(
                        child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: null,
                        ),
                        onTapUp: onSearchTapUp,
                      ),
                    ],
                  ),
                  AnimatedBuilder(
                    animation: _animationRipple,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: MyPainter(
                          containerHeight: _animationHeight.value,
                          center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                          radius: _animationRipple.value *
                              MediaQuery.of(context).size.width,
                          color: Colors.grey,
                          context: context,
                        ),
                      );
                    },
                  ),
                  _expanded
                      ? AppBar(
                          backgroundColor: Colors.grey,
                          title: Text('Expanded'),
                          actions: [
                            GestureDetector(
                              child: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: null,
                              ),
                              onTapUp: cancelSearch,
                            ),
                          ],
                        )
                      : Container()
                ],
              ))
          : null,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
