import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mawaqit/src/helpers/RelativeSizes.dart';
import 'package:mawaqit/src/helpers/repaint_boundaries.dart';
import 'package:mawaqit/src/mawaqit_image/mawaqit_image_cache.dart';
import 'package:mawaqit/src/models/announcement.dart';
import 'package:mawaqit/src/pages/home/sub_screens/normal_home.dart';
import 'package:mawaqit/src/pages/home/widgets/AboveSalahBar.dart';
import 'package:mawaqit/src/pages/home/widgets/workflows/WorkFlowWidget.dart';
import 'package:mawaqit/src/services/mosque_manager.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../widgets/salah_items/responsive_mini_salah_bar_widget.dart';

/// show all announcements in one after another
class AnnouncementScreen extends StatelessWidget {
  AnnouncementScreen({
    Key? key,
    this.onDone,
    this.enableVideos = true,
  }) : super(key: key);

  final VoidCallback? onDone;

  /// used to disable videos on mosques
  final bool enableVideos;

  @override
  Widget build(BuildContext context) {
    final announcements = context.read<MosqueManager>().activeAnnouncements(enableVideos);

    if (announcements.isEmpty) return NormalHomeSubScreen();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ContinuesWorkFlowWidget(
          onDone: onDone,
          workFlowItems: announcements
              .map((e) => WorkFlowItem(
                    builder: (context, next) => announcementWidgets(e, nextAnnouncement: next),
                    duration: e.video != null ? null : Duration(seconds: e.duration ?? 30),
                  ))
              .toList(),
        ),
        // announcementWidgets(),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.vh),
            child: AboveSalahBar(),
          ),
        ),
        IgnorePointer(
          child: Padding(padding: EdgeInsets.only(bottom: 1.5.vh), child: ResponsiveMiniSalahBarWidget()),
        )
      ],
    );
  }

  /// return the widget of the announcement based on its type
  Widget announcementWidgets(Announcement activeAnnouncement, {VoidCallback? nextAnnouncement}) {
    if (activeAnnouncement.content != null) {
      return _TextAnnouncement(
        content: activeAnnouncement.content!,
        title: activeAnnouncement.title,
      );
    } else if (activeAnnouncement.image != null) {
      return _ImageAnnouncement(
        image: activeAnnouncement.image!,
        onError: nextAnnouncement,
      );
    } else if (activeAnnouncement.video != null) {
      return _VideoAnnouncement(
        key: ValueKey(activeAnnouncement.video),
        url: activeAnnouncement.video!,
        onEnded: nextAnnouncement,
      );
    }

    return SizedBox();
  }
}

class _TextAnnouncement extends StatelessWidget {
  const _TextAnnouncement({Key? key, required this.title, required this.content}) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: ValueKey("$content $title"),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          // title
          SizedBox(height: 10.vh),
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              shadows: kAnnouncementTextShadow,
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
              letterSpacing: 1,
            ),
          ).animate().slide().addRepaintBoundary(),
          // content
          SizedBox(height: 3.vh),
          Expanded(
            child: AutoSizeText(
              content,
              stepGranularity: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                shadows: kAnnouncementTextShadow,
                fontSize: 8.vwr,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ).animate().fade(delay: 500.milliseconds).addRepaintBoundary(),
          ),
          SizedBox(height: 20.vh),
        ],
      ),
    );
  }

  get kAnnouncementTextShadow => [
        Shadow(
          offset: Offset(0, 9),
          blurRadius: 15,
          color: Colors.black54,
        ),
      ];
}

class _ImageAnnouncement extends StatelessWidget {
  const _ImageAnnouncement({
    Key? key,
    required this.image,
    this.onError,
  }) : super(key: key);

  final String image;

  /// used to skip to the next announcement if the image failed to load
  final VoidCallback? onError;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: MawaqitNetworkImageProvider(image, onError: onError),
      fit: BoxFit.fitWidth,
      width: double.infinity,
      height: double.infinity,
    ).animate().slideX().addRepaintBoundary();
  }
}

class _VideoAnnouncement extends StatefulWidget {
  const _VideoAnnouncement({
    Key? key,
    required this.url,
    this.onEnded,
  }) : super(key: key);

  final String url;
  final VoidCallback? onEnded;

  @override
  State<_VideoAnnouncement> createState() => _VideoAnnouncementState();
}

class _VideoAnnouncementState extends State<_VideoAnnouncement> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final mosqueManager = context.read<MosqueManager>();

    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: mosqueManager.typeIsMosque,
        useHybridComposition: false,
        hideControls: true,
        forceHD: true,
      ),
    );

    /// if announcement didn't started playing after 20 seconds skip it
    Future.delayed(20.seconds, () {
      if (_controller.value.isReady == false) widget.onEnded?.call();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onEnded: (metaData) => widget.onEnded?.call(),
        ),
      ),
    );
  }
}
