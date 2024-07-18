enum LottieAnimation {
  facebook(
    name: 'facebook',
    duration: Duration(seconds: 1),
  ),

  gmail(
    name: 'gmail-sign',
    duration: Duration(seconds: 1),
  ),

  splash(
    name: 'splash',
    duration: Duration(seconds: 1),
  ),

  loading(
    name: 'loading',
    duration: Duration(seconds: 1),
  ),

  empty(
    name: 'empty',
    duration: Duration(seconds: 1),
  ),

  error(
    name: 'error',
    duration: Duration(seconds: 1),
  );

  final String name;
  final Duration duration;
  const LottieAnimation({required this.name, required this.duration});
}

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}
