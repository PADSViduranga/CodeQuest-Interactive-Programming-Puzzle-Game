class AppRoutes {
  AppRoutes._();

  // Auth
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';

  // Setup
  static const chooseLanguage = '/choose-language';
  static const chooseLevel = '/choose-level';

  // Main
  static const home = '/home';
  static const lesson = '/lesson/:stageId';
  static String lessonPath(String stageId) => '/lesson/$stageId';
  static const stageComplete = '/stage-complete';
  static const levelUp = '/level-up';
  static const badge = '/badge';
  static const profile = '/profile';
  static const settings = '/settings';
  static const privacy = '/privacy';
  static const deleteAccount = '/delete-account';
}
