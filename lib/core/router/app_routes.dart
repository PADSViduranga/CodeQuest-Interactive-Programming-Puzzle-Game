class AppRoutes {
  AppRoutes._();

  // Start and auth
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const resetPassword = '/reset-password';

  // Setup
  static const chooseLanguage = '/choose-language';
  static const chooseLevel = '/choose-level';
  static const chooseAvatar = '/choose-avatar';

  // Main tabs
  static const home = '/home';
  static const daily = '/daily';
  static const leaderboard = '/leaderboard';
  static const progress = '/progress';
  static const profile = '/profile';

  // World and play
  static const world = '/world/:worldId';
  static const lesson = '/lesson/:lessonId';
  static const play = '/play/:stageId';
  static const results = '/results';
  static const miniGames = '/mini-games';
  static const shop = '/shop';

  // Player
  static const editProfile = '/profile/edit';
  static const achievements = '/achievements';
  static const settings = '/settings';
  static const privacy = '/privacy';
  static const deleteAccount = '/delete-account';

  // Admin
  static const admin = '/admin';
  static const adminAnalytics = '/admin/analytics';
  static const adminUsers = '/admin/users';
  static const adminContent = '/admin/content';
  static const adminReports = '/admin/reports';
}
