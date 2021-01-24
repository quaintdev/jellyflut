import 'package:flutter/material.dart';
import 'package:jellyflut/components/banner/LeftBanner.dart';
import 'package:jellyflut/components/banner/RightBanner.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progressBar.dart';
import 'package:jellyflut/models/ScreenDetailsArgument.dart';
import 'package:jellyflut/models/item.dart';
import 'package:jellyflut/screens/details/details.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.showName = true,
      this.showParent = true,
      this.type = 'Primary',
      this.boxFit = BoxFit.cover});

  final Item item;
  final String heroTag;
  final Color textColor;
  final bool showName;
  final bool showParent;
  final String type;
  final BoxFit boxFit;

  @override
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster> {
  final BoxShadow boxShadowjellyPurple =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);

  final BoxShadow boxShadowColor2 =
      BoxShadow(blurRadius: 4, color: Colors.black12, spreadRadius: 2);

  String heroTag;

  ScreenDetailsArguments screenDetailsArguments;
  @override
  Widget build(BuildContext context) {
    heroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Details(item: widget.item, heroTag: heroTag)),
            ),
        child: body(heroTag, context));
  }

  Widget body(String heroTag, BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.item.getPrimaryAspectRatio(),
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Stack(fit: StackFit.expand, children: [
                      Hero(
                          tag: heroTag,
                          child: Poster(
                              showParent: widget.showParent,
                              type: widget.type,
                              boxFit: widget.boxFit,
                              item: widget.item)),
                      Stack(
                        children: [
                          if (widget.item.isNew())
                            Positioned(top: 8, left: 0, child: newBanner()),
                          if (widget.item.userData.played)
                            Positioned(top: 8, right: 0, child: playedBanner()),
                        ],
                      ),
                      if (widget.item.userData.playbackPositionTicks != null &&
                          widget.item.userData.playbackPositionTicks > 0)
                        Positioned.fill(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: progressBar())),
                    ]),
                  ),
                ],
              ),
            ),
            if (widget.showName)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.showParent
                              ? widget.item.parentName()
                              : widget.item.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.textColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
          ]),
    );
  }

  Widget newBanner() {
    return CustomPaint(
        painter: LeftBanner(color: Colors.red[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Text('NEW',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontWeight: FontWeight.bold))));
  }

  Widget playedBanner() {
    return CustomPaint(
        painter: RightBanner(color: Colors.green[700]),
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )));
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: widget.item)));
  }
}
