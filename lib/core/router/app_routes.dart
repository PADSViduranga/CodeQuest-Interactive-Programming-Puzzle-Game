class AppRoutes {
  AppRoutes._();

  // Auth
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';

  // Setup
  static const chooseLanguage = '/choose-language';
  static const chooseLevel = '/choose-level';

  // Main tabs
  static const home = '/home';
  static const daily = '/daily';
  static const leaderboard = '/leaderboard';
  static const progress = '/progress';
  static const profile = '/profile';

  // Pages opened on top of the tabs
  static const lesson = '/lesson/:stageId';
  static String lessonPath(String stageId) => '/lesson/$stageId';
  static const play = '/play/:stageId';
  static const editProfile = '/edit-profile';
  static const stageComplete = '/stage-complete';
  static const levelUp = '/level-up';
  static const badge = '/badge';
  static const achievements = '/achievements';
  static const settings = '/settings';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const miniGames = '/minigames';
  static const deleteAccount = '/delete-account';
}
