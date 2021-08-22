import 'package:flutter/widgets.dart';
import 'package:jellyflut/screens/stream/components/backwardButton.dart';
import 'package:jellyflut/screens/stream/components/forwardButton.dart';
import 'package:jellyflut/screens/stream/components/playPauseButton.dart';
import 'package:jellyflut/screens/stream/components/videoPlayerProgressBar.dart';
import 'package:jellyflut/shared/responsiveBuilder.dart';
import 'chapterButton.dart';

class BottomRowPlayerControls extends StatelessWidget {
  const BottomRowPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder.builder(
        mobile: () => smallBottomRow(),
        tablet: () => largeBottomRow(),
        desktop: () => largeBottomRow());
  }

  Widget smallBottomRow() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 1, child: PlayPauseButton()),
          Expanded(flex: 9, child: VideoPlayerProgressBar()),
          Spacer(flex: 1)
        ]);
  }

  Widget largeBottomRow() {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Flexible(flex: 8, child: VideoPlayerProgressBar()),
              Spacer(flex: 1)
            ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackwardButton(),
              PlayPauseButton(),
              ForwardButton(),
              ChapterButton()
            ]),
      ],
    );
  }
}
