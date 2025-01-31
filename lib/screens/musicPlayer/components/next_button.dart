import 'package:flutter/material.dart';

import 'package:jellyflut/providers/music/music_provider.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';

class NextButton extends StatefulWidget {
  final Color color;
  final Color backgroundColor;
  NextButton({Key? key, required this.color, required this.backgroundColor})
      : super(key: key);

  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  late final MusicProvider musicProvider;
  late final FocusNode _node;
  final List<BoxShadow> shadows = [
    BoxShadow(color: Colors.black45, blurRadius: 4, spreadRadius: 2)
  ];

  @override
  void initState() {
    _node = FocusNode();
    musicProvider = MusicProvider();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        onPressed: () => musicProvider.next(),
        node: _node,
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              boxShadow: shadows,
              shape: BoxShape.circle),
          child: Icon(
            Icons.skip_next,
            color: widget.color,
            size: 32,
          ),
        ));
  }
}
