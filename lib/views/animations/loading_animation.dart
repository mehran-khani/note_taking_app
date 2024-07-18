import 'package:note_taking_app/views/animations/lottie_animation_view.dart';
import 'package:note_taking_app/views/animations/models/lottie_animation.dart';

class LoadingAnimationView extends LottieAnimationView {
  const LoadingAnimationView({super.key})
      : super(
            animation: LottieAnimation.loading,
            animationDuration: 800,
            animationPause: 1);
}
