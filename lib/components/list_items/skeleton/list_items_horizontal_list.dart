part of 'list_items_skeleton.dart';

class ListItemsHorizontalSkeleton extends StatelessWidget {
  final count;
  ListItemsHorizontalSkeleton({this.count = 10});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: shimmerColor1,
        highlightColor: shimmerColor2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: horizontalListPosterHeight,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) => SkeletonItemPoster(
                      height: horizontalListPosterHeight,
                      padding: EdgeInsets.only(right: 8),
                    )),
          ),
        ));
  }
}
