import 'package:flutter/material.dart';
import 'package:whatsapp_appbar/painter.dart';

class SearchScaffold extends StatefulWidget {
  final AppBar appBar;
  final Widget body;
  final FloatingActionButton floatingActionButton;

  SearchScaffold({
    this.appBar,
    this.body,
    this.floatingActionButton,
  });

  @override
  SearchScaffoldState createState() => SearchScaffoldState();
}

class SearchScaffoldState extends State<SearchScaffold>
    with TickerProviderStateMixin {
  AnimationController _controllerHeight;
  AnimationController _controllerRipple;
  Animation _animationHeight;
  Animation _animationRipple;
  bool _expanded = false;
  double rippleStartX = 0;
  double rippleStartY = 0;
  FocusNode _focusNode = FocusNode();

  Tween<double> _tweenHeight = Tween(
    begin: 56,
    end: 180,
  )..chain(CurveTween(curve: Curves.elasticOut));

  Tween<double> _tweenRipple = Tween(
    begin: 0,
    end: 1.1,
  )..chain(CurveTween(curve: Curves.elasticOut));

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        _expanded = true;
      });
      _focusNode.requestFocus();
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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(_animationHeight.value),
          child: Stack(
            children: [
              AppBar(
                title: Text('Search Appbar'),
                actions: [
                  GestureDetector(
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
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
                      color: Colors.white,
                      context: context,
                    ),
                  );
                },
              ),
              _expanded
                  ? Container(
                      height: _animationHeight.value +
                          MediaQuery.of(context).padding.top,
                      child: SafeArea(
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                    new EdgeInsets.symmetric(vertical: 20.0),
                                prefixIcon: GestureDetector(
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.black38),
                                    onPressed: null,
                                  ),
                                  onTapUp: cancelSearch,
                                ),
                                hintText: 'Search...',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black12),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black12),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black12),
                                ),
                              ),
                              cursorColor: Colors.black12,
                              focusNode: _focusNode,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Chip(
                                          label: Text(
                                            'Photos',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.photo,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                      Chip(
                                          label: Text(
                                            'Videos',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.videocam,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                      Chip(
                                          label: Text(
                                            'Links',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.link,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Chip(
                                          label: Text(
                                            'GIFs',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.gif,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                      Chip(
                                          label: Text(
                                            'Audio',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.headset,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                      Chip(
                                          label: Text(
                                            'Documents',
                                            style: TextStyle(
                                                color: Colors.black87),
                                          ),
                                          avatar: Icon(Icons.insert_drive_file,
                                              size: 18, color: Colors.black54)),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
