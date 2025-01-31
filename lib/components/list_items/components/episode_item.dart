import 'package:flutter/material.dart';

import 'package:jellyflut/components/critics.dart';
import 'package:jellyflut/components/poster/poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/routes/router.gr.dart';
import 'package:jellyflut/screens/details/template/components/items_collection/outlined_button_selector.dart';
import 'package:jellyflut/shared/shared.dart';
import 'package:uuid/uuid.dart';

class EpisodeItem extends StatefulWidget {
  final bool clickable;
  final Item item;

  const EpisodeItem({Key? key, required this.item, this.clickable = true})
      : super(key: key);

  @override
  _EpisodeItemState createState() => _EpisodeItemState();
}

class _EpisodeItemState extends State<EpisodeItem>
    with SingleTickerProviderStateMixin {
  // Dpad navigation
  late final FocusNode _node;
  late final String posterHeroTag;

  @override
  void initState() {
    posterHeroTag = Uuid().v4();
    _node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  void _onTap(String heroTag) {
    customRouter.push(DetailsRoute(item: widget.item, heroTag: heroTag));
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButtonSelector(
        node: _node,
        onPressed: () => _onTap(posterHeroTag),
        child: epsiodeItem());
  }

  Widget epsiodeItem() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final rightPartPadding = constraints.maxWidth < 350
          ? const EdgeInsets.only(left: 0)
          : const EdgeInsets.only(left: 8);
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (constraints.maxWidth > 350)
              Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          minWidth: 20, maxWidth: constraints.maxWidth * 0.4),
                      child: poster())),
            Expanded(
              child: Padding(
                  padding: rightPartPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          children: [
                            if (widget.item.hasRatings())
                              Critics(
                                item: widget.item,
                                fontSize: 18,
                              ),
                            if (widget.item.getDuration() != 0) duration()
                          ],
                        ),
                      ),
                      if (widget.item.overview != null) overview()
                    ],
                  )),
            )
          ],
        ),
      );
    });
  }

  Widget poster() {
    return AspectRatio(
      aspectRatio: widget.item.getPrimaryAspectRatio(),
      child: Poster(
          key: ValueKey(widget.item),
          tag: ImageType.PRIMARY,
          heroTag: '${widget.item.id}-${Uuid().v1()}-${widget.item.name}',
          clickable: false,
          width: double.infinity,
          height: double.infinity,
          boxFit: BoxFit.cover,
          item: widget.item),
    );
  }

  Widget title() {
    final title = widget.item.indexNumber != null
        ? '${widget.item.indexNumber} - ${widget.item.name}'
        : '${widget.item.name}';

    return Flexible(
      child: Text(title,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget duration() {
    return Flexible(
        child: Text(
            printDuration(Duration(microseconds: widget.item.getDuration())),
            maxLines: 1,
            style:
                Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)));
  }

  Widget overview() {
    return Flexible(
      child: Text(
        widget.item.overview!,
        textAlign: TextAlign.justify,
        maxLines: 4,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
      ),
    );
  }
}
