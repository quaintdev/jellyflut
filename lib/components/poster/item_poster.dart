import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/components/poster/progress_bar.dart';
import 'package:jellyflut/components/sliding_text.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/screens/details/components/logo.dart';
import 'package:uuid/uuid.dart';

class ItemPoster extends StatefulWidget {
  const ItemPoster(this.item,
      {this.textColor = Colors.white,
      this.heroTag,
      this.widgetAspectRatio,
      this.showName = true,
      this.showParent = true,
      this.showOverlay = true,
      this.showLogo = false,
      this.clickable = true,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.cover});

  final Item item;
  final String? heroTag;
  final double? widgetAspectRatio;
  final Color textColor;
  final bool showName;
  final bool showParent;
  final bool showOverlay;
  final bool showLogo;
  final bool clickable;
  final ImageType tag;
  final BoxFit boxFit;

  @override
  _ItemPosterState createState() => _ItemPosterState();
}

class _ItemPosterState extends State<ItemPoster>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  // Dpad navigation
  late final FocusNode _node;
  late final String posterHeroTag;
  late final double aspectRatio;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _node = FocusNode();
    posterHeroTag = widget.heroTag ?? widget.item.id + Uuid().v4();
    aspectRatio = widget.widgetAspectRatio ??
        widget.item.getPrimaryAspectRatio(showParent: widget.showParent);
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AspectRatio(aspectRatio: aspectRatio, child: body(context));
  }

  Widget body(BuildContext context) {
    return Column(children: [
      Expanded(
          flex: 10,
          child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                        aspectRatio: aspectRatio,
                        child: Stack(children: [
                          Poster(
                              showParent: widget.showParent,
                              tag: widget.tag,
                              clickable: widget.clickable,
                              heroTag: posterHeroTag,
                              boxFit: widget.boxFit,
                              item: widget.item),
                          if (widget.showOverlay)
                            IgnorePointer(
                                child: Stack(
                              children: [
                                if (widget.item.isNew())
                                  Positioned(
                                      top: 8, left: 8, child: newBanner()),
                                if (widget.item.isPlayed())
                                  Positioned(
                                      top: 8, right: 8, child: playedBanner()),
                              ],
                            )),
                          if (widget.showLogo && widget.showOverlay)
                            IgnorePointer(
                                child: Align(
                              alignment: Alignment.center,
                              child: Logo(
                                item: widget.item,
                                size: Size.infinite,
                              ),
                            )),
                          if (widget.item.hasProgress() && widget.showOverlay)
                            progress(),
                        ])),
                  ]))),
      if (widget.showName) Flexible(flex: 2, child: name())
    ]);
  }

  Widget progress() {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(child: progressBar())));
  }

  Widget name() {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: SlidingText(
              text: widget.showParent
                  ? widget.item.parentName()
                  : widget.item.name,
              blankSpace: 300,
              velocity: 80.0,
              pauseAfterRound: Duration(seconds: 3),
              fontSize: 18,
            ),
          ),
        ),
        if (widget.item.isFolder != null &&
            widget.item.parentIndexNumber != null)
          Text(
            'Season ${widget.item.parentIndexNumber}, Episode ${widget.item.indexNumber}',
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }

  Widget newBanner() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.blue.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)
          ]),
      child: Icon(
        Icons.new_releases,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Widget playedBanner() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.green.shade700,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(blurRadius: 4, color: Colors.black54, spreadRadius: 2)
          ]),
      child: Icon(
        Icons.check,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  Widget progressBar() {
    return FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.2,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProgressBar(item: widget.item)));
  }

  MaterialStateProperty<double> buttonElevation() {
    return MaterialStateProperty.resolveWith<double>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return 2;
        } else if (states.contains(MaterialState.hovered)) {
          return 6;
        }
        return 0; // defer to the default
      },
    );
  }

  MaterialStateProperty<BorderSide> buttonBorderSide() {
    return MaterialStateProperty.resolveWith<BorderSide>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.focused)) {
          return BorderSide(
            width: 2,
            color: Colors.white,
          );
        }
        return BorderSide(
            width: 0, color: Colors.transparent); // defer to the default
      },
    );
  }
}
