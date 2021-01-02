import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_appbar/painter.dart';

class SearchScaffold extends StatefulWidget {
  final String labelSearch;
  final Widget bodySearch;
  final Widget searchBottom;
  final double maxHeight;
  final double minHeight;
  final Function(String value) onChange;
  final Function(String value) onSubmit;

  final AppBar appBar;
  final Widget body;
  final FloatingActionButton floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonAnimator floatingActionButtonAnimator;
  final List<Widget> persistentFooterButtons;
  final Widget drawer;
  final Widget endDrawer;
  final Color drawerScrimColor;
  final Widget bottomNavigationBar;
  final Widget bottomSheet;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  SearchScaffold({
    this.labelSearch = '',
    this.bodySearch,
    this.searchBottom,
    this.maxHeight = 180,
    this.minHeight = 56,
    this.onChange,
    this.onSubmit,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
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
  Tween<double> _tweenHeight;
  Tween<double> _tweenRipple;
  FocusNode _focusNode = FocusNode();

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
    _tweenHeight = Tween(
      begin: widget.minHeight,
      end: widget.maxHeight,
    )..chain(CurveTween(curve: Curves.elasticOut));

    _tweenRipple = Tween(
      begin: 0,
      end: 1.25,
    )..chain(CurveTween(curve: Curves.elasticOut));

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
                title: widget.appBar?.title ?? '',
                actions: [
                  ...(widget.appBar?.actions ?? []),
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
                                hintText: widget.labelSearch,
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
                            widget.searchBottom ?? Container(),
                          ],
                        ),
                      ),
                    )
                  : Container()
            ],
          )),
      body: _expanded ? widget.bodySearch : widget.body,
      floatingActionButton: widget.floatingActionButton,
      backgroundColor: widget.backgroundColor,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      drawerScrimColor: widget.drawerScrimColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
    );
  }
}
