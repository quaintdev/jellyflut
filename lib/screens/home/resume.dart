import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:jellyflut/components/poster/item_poster.dart';
import 'package:jellyflut/globals.dart';
import 'package:jellyflut/models/enum/image_type.dart';
import 'package:jellyflut/models/jellyfin/category.dart';
import 'package:jellyflut/providers/home/home_provider.dart';
import 'package:jellyflut/services/item/item_service.dart';
import 'package:jellyflut/theme.dart';
import 'package:shimmer/shimmer.dart';

class Resume extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResumeState();
  }
}

class _ResumeState extends State<Resume> {
  final String categoryTitle = 'resume';
  final double scalePosterSizeValue = 0.8;
  late Future<Category> categoryFuture;
  late final HomeCategoryProvider homeCategoryprovider;

  @override
  void initState() {
    categoryFuture = ItemService.getResumeItems();
    homeCategoryprovider = HomeCategoryProvider();
    checkIfCategoryInitialized();
    super.initState();
  }

  @override
  Widget build(Object context) {
    return categoryBuilder();
  }

  /// Prevent from re-query the API on resize
  Widget categoryBuilder() {
    if (homeCategoryprovider.isCategoryPresent(categoryTitle)) {
      final items = homeCategoryprovider.getCategoryItem(categoryTitle);
      if (items.isNotEmpty) {
        return body();
      } else {
        return const SizedBox();
      }
    } else {
      return FutureBuilder<Category>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            var _items = snapshot.data!.items;
            if (_items.isNotEmpty) {
              return body();
            } else {
              return const SizedBox();
            }
          }
          return placeholder();
        },
      );
    }
  }

  Widget body() {
    final items = homeCategoryprovider.getCategoryItem(categoryTitle);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'resume',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ).tr(),
        ),
        SizedBox(
            height: (itemPosterHeight + itemPosterLabelHeight) *
                scalePosterSizeValue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                var _item = items[index];
                return ItemPoster(
                  _item,
                  width: double.infinity,
                  height: double.infinity,
                  showLogo: true,
                  imagefilter: true,
                  backup: false,
                  tag: ImageType.BACKDROP,
                  widgetAspectRatio: 16 / 9,
                );
              },
            ))
      ],
    );
  }

  Widget placeholder() {
    return Shimmer.fromColors(
        enabled: shimmerAnimation,
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 15, 5, 5),
                    height: 30,
                    width: 70,
                    color: Colors.white30,
                  )),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 200,
                              child: ListView.builder(
                                  itemCount: 3,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 4, 8, 4),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          child: Container(
                                            height: 200,
                                            width: 200 * (2 / 3),
                                            color: Colors.white30,
                                          )))))),
                    ],
                  ))
            ]));
  }

  void checkIfCategoryInitialized() {
    // If category is not present then we load datas from API endpoint
    if (!homeCategoryprovider.isCategoryPresent(categoryTitle)) {
      // get datas
      categoryFuture = ItemService.getResumeItems();

      // Add category to BLoC
      categoryFuture.then((value) => homeCategoryprovider
          .addCategory(MapEntry(categoryTitle, value.items)));
    } else {
      categoryFuture = Future.value(Category(
          items: homeCategoryprovider.getCategoryItem(categoryTitle),
          totalRecordCount: 0,
          startIndex: 0));
    }
  }
}
