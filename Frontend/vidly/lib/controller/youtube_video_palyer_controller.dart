
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class XYoutubePlayerController extends GetxController {
    late  YoutubePlayerController controller ;

  @override
  void onInit() {
    super.onInit();
    initializeController();
  }

  void initializeController() {
    controller = YoutubePlayerController(
      initialVideoId: "https://youtu.be/sx6mFB-Pg0A",
      // Provide a default video ID here
      params: const YoutubePlayerParams(
        loop: true,
        color: 'transparent',
        showControls: true,
        desktopMode: true,
        mute: false,
        strictRelatedVideos: true,
        showFullscreenButton: true,
      ),
    );
  }

  //YoutubePlayerController get controller => controller;

  void changeVideo(String videoUrl) {

    controller.load(YoutubePlayerController.convertUrlToId(videoUrl)!);
  }

  @override
  void onClose() {
    controller.close();
    super.onClose();
  }
}
