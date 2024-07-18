import 'package:note_taking_app/views/animations/lottie_animation_view.dart';
import 'package:note_taking_app/views/animations/models/lottie_animation.dart';

class SplashAnimationView extends LottieAnimationView {
  const SplashAnimationView({super.key})
      : super(
          animation: LottieAnimation.splash,
          animationDuration: 1500,
        );
}
