import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../services/mosque_manager.dart';

class JummuaLive extends StatefulWidget {
  const JummuaLive({Key? key}) : super(key: key);

  @override
  State<JummuaLive> createState() => _JummuaLiveState();
}

class _JummuaLiveState extends State<JummuaLive> {
  @override
  Widget build(BuildContext context) {
    // final mosqueProvider = context.watch<MosqueManager>();
    //
    // if (mosqueProvider.mosque == null || mosqueProvider.times == null) return SizedBox();
    //
    // final mosque = mosqueProvider.mosque!;
    return liveStream("https://www.youtube.com/watch?v=hrnT2IFqyro");
  }

  Widget liveStream(String video) {
    late YoutubePlayerController _controller = YoutubePlayerController(

      initialVideoId: YoutubePlayer.convertUrlToId(
        video,
      )!,
      flags: YoutubePlayerFlags(
        showLiveFullscreenButton: false,
        isLive: true,
        hideControls: true,
        autoPlay: true,

      ),

    );
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }
}
