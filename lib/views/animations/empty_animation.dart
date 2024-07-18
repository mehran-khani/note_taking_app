import 'package:note_taking_app/views/animations/lottie_animation_view.dart';
import 'package:note_taking_app/views/animations/models/lottie_animation.dart';

class EmptyAnimationView extends LottieAnimationView {
  const EmptyAnimationView({super.key})
      : super(
            animation: LottieAnimation.empty,
            animationPause: 2,
            animationDuration: 1800);
}
