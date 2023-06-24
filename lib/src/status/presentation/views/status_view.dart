import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whatsapp/core/common/views/loading_screen.dart';
import 'package:whatsapp/src/status/models/status.dart';

class StatusView extends StatefulWidget {
  const StatusView(this.status, {super.key});

  final Status status;

  static const id = '/status-view';

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final controller = StoryController();
  List<StoryItem> stories = [];

  void initStoryItems() {
    for (var i = 0; i < widget.status.photoURLs.length; i++) {
      final media = widget.status.photoURLs[i];
      // TODO(STORY): add captions and different media types
      stories.add(
        StoryItem.pageImage(
          url: media,
          controller: controller,
        ),
      );
      // if (/*media.mediaType == MediaType.image*/) {
      //   stories.add(
      //     StoryItem.pageImage(
      //       url: media,
      //       controller: controller,
      //       caption: widget.status.caption,
      //     ),
      //   );
      // } else {
      //   stories.add(
      //     StoryItem.pageVideo(
      //       mediaUrl: media.mediaUrl,
      //       controller: controller,
      //       caption: widget.status.caption,
      //     ),
      //   );
      // }
    }
  }

  @override
  void initState() {
    super.initState();
    initStoryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stories.isEmpty
          ? const LoadingScreen()
          : StoryView(
              storyItems: stories,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                } /*else if(direction == Direction.left) {
                  if (widget.status.nextStatus != null) {
                    Navigator.of(context).pushReplacementNamed(
                      StatusView.id,
                      arguments: widget.status.nextStatus,
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                }*/
              },
              onComplete: () {
                if (widget.status.nextStatus != null) {
                  Navigator.of(context).pushReplacementNamed(
                    StatusView.id,
                    arguments: widget.status.nextStatus,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
    );
  }
}
