// class ApiConstants {
//   static const String baseUrl = 'http://127.0.0.1:8000/api';
//   static const String signupEndpoint = '$baseUrl/sign_up';
// }t

class ApiEndPoints {
  static final String baseUrl = 'https://sikawan.api.dev.ts.atnava.com/api/';
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
  static _HistoryEndPoints historyEndPoints = _HistoryEndPoints();
  static _ProfileEndPoints profileEndPoints = _ProfileEndPoints();
  static _ProjectsListEndPoints projectslistEndPoints =
      _ProjectsListEndPoints();
  static _EntryEndPoints entryEndPoints = _EntryEndPoints();
}

class _AuthEndPoints {
  final String signup = 'sign_up';
  final String login = 'login';
  final String forgotpassword = 'forgot_password';
  final String logout = 'logout';
  final String uploadphoto = 'upload_photo';
  final String getphoto = 'get_photo';
}

class _HistoryEndPoints {
  final String history = 'history';
}

class _ProfileEndPoints {
  final String profile = 'profile';
  final String statistic = 'statistic';
}

class _ProjectsListEndPoints {
  final String projectslist = 'projects';
  final String projectDetail = 'projects';
}

class _EntryEndPoints {
  final String entry = 'entry';
  final String exit = 'exit';
}
