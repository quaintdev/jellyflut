import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/item.dart';
import 'package:jellyflut/services/item/item_image_service.dart';
import 'package:jellyflut/shared/utils/blurhash_util.dart';
import 'package:octo_image/octo_image.dart';

class AsyncImage extends StatefulWidget {
  final Item item;
  final ImageType tag;
  final BoxFit boxFit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? width;
  final double? height;
  final bool showParent;
  final bool backup;

  /// Class to construct a class which return widget with image associated to parameters
  ///
  /// * [backup] mean to force parameter to search image and if there is no results then we return empty SizedBox
  /// * [showParent] mean to user parentid to load image datas
  /// * [placeholder] can be used to determine a placeholder while loading image
  const AsyncImage(
      {required this.item,
      Key? key,
      this.tag = ImageType.PRIMARY,
      this.boxFit = BoxFit.fitHeight,
      this.placeholder,
      this.errorWidget,
      this.width,
      this.height,
      this.backup = true,
      this.showParent = false})
      : super(key: key);

  @override
  _AsyncImageState createState() => _AsyncImageState();
}

class _AsyncImageState extends State<AsyncImage> {
  late final Widget child;
  late final String itemId;
  late final String? hash;
  late final ImageType imageType;
  late final String? imageTag;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    itemId = widget.showParent
        ? widget.item.getParentId()
        : widget.item.correctImageId();
    hash =
        BlurHashUtil.fallBackBlurHash(widget.item.imageBlurHashes, widget.tag);
    imageType = widget.backup
        ? widget.item.correctImageType(searchType: widget.tag)
        : widget.tag;
    imageTag = widget.backup
        ? widget.item.correctImageTags(searchType: widget.tag)
        : widget.item
            .getImageTagBySearchTypeOrNull(searchType: widget.tag)
            ?.value;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)), child: builder());
  }

  Widget builder() {
    final url =
        ItemImageService.getItemImageUrl(itemId, imageTag, type: imageType);
    if (widget.width != null && widget.height != null) {
      return OctoImage(
          image: CachedNetworkImageProvider(url),
          placeholderBuilder: imagePlaceholder(hash),
          errorBuilder: imagePlaceholderError(hash),
          fit: widget.boxFit,
          width: widget.width,
          height: widget.height,
          fadeInDuration: Duration(milliseconds: 300));
    } else {
      return OctoImage(
          image: CachedNetworkImageProvider(url),
          placeholderBuilder: imagePlaceholder(hash),
          errorBuilder: imagePlaceholderError(hash),
          fit: widget.boxFit,
          fadeInDuration: Duration(milliseconds: 300));
    }
  }

  Widget Function(BuildContext, Object, StackTrace?) imagePlaceholderError(
      String? hash) {
    if (widget.errorWidget != null) {
      return (_, o, e) => widget.errorWidget!;
    }

    if (hash != null) {
      if (widget.tag != ImageType.LOGO) {
        return OctoError.blurHash(hash, icon: Icons.warning_amber_rounded);
      }
      return (_, o, e) => const SizedBox();
    }
    return (_, o, e) =>
        widget.errorWidget != null ? widget.errorWidget! : noPhotoActor();
  }

  Widget Function(BuildContext) imagePlaceholder(String? hash) {
    if (widget.placeholder != null) {
      return (_) => widget.placeholder!;
    }

    // If we don't have any hash then we don't have image so --> placeholder
    if (hash != null) {
      // If we show a Logo we don't load blurhash as it's a bit ugly
      if (widget.tag != ImageType.LOGO) {
        return OctoPlaceholder.blurHash(hash);
      }
      return (_) => const SizedBox();
    }
    return (_) =>
        widget.placeholder != null ? widget.placeholder! : noPhotoActor();
  }

  Widget noPhotoActor() {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(Icons.no_photography, color: Colors.white),
      ),
    );
  }
}
