import 'package:note_taking_app/views/animations/lottie_animation_view.dart';
import 'package:note_taking_app/views/animations/models/lottie_animation.dart';

class ErrorAnimationView extends LottieAnimationView {
  const ErrorAnimationView({super.key})
      : super(animation: LottieAnimation.error);
}
