import 'package:flutter/material.dart';

import 'package:jellyflut/components/async_image.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';

class PlaceholderScreen extends StatelessWidget {
  final Item? item;
  const PlaceholderScreen({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return CircularProgressIndicator();
    }
    return itemPlacheholder();
  }

  Widget itemPlacheholder() {
    final item = this.item!;
    return AsyncImage(
        item: item,
        width: double.infinity,
        height: double.infinity,
        boxFit: BoxFit.fitHeight,
        tag: ImageType.BACKDROP,
        showParent: true,
        backup: false);
  }
}
