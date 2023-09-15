import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stom_club/entities/auth_token.dart';
import 'package:stom_club/entities/authorization.dart';
import 'package:stom_club/entities/user.dart';

class UserService {
  late SharedPreferences _sharedPreferences;

  void setAppStatus(bool isFirstAppStart) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setBool('app_status', isFirstAppStart);
  }

  void setAuth(Authorization authorization) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('authorization', authorization.toRawJson());
  }

  void setProfessionId(int professionId) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setInt('profession_id', professionId);
  }

  void setToken(AuthToken authToken) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('token', authToken.toRawJson());
  }

  void setTokenDate(DateTime dateTime) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('token_date', dateTime.toIso8601String());
  }

  void setUser(User user) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('user', user.toRawJson());
  }

  void clear() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.clear();

    /// SET FIRST APP START STATUS
    setAppStatus(true);
  }

  Future<bool> getAppStatus() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getBool('app_status') ?? false;
  }

  Future<Authorization?> getAuth() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    if (_sharedPreferences.containsKey('authorization')) {
      dynamic json = _sharedPreferences.getString('authorization');
      return Authorization.fromRawJson(json);
    }

    return null;
  }

  Future<int> getProfessionId() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences.getInt('profession_id') ?? 1;
  }

  Future<AuthToken?> getToken() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey('token')) {
      dynamic json = _sharedPreferences.getString('token');
      return AuthToken.fromRawJson(json);
    }
    return null;
  }

  Future<DateTime?> getTokenDate() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey('token_date')) {
      String value = _sharedPreferences.getString('token_date')!;
      return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(value);
    }
    return null;
  }

  Future<User?> getUser() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey('user')) {
      dynamic json = _sharedPreferences.getString('user');
      return User.fromRawJson(json);
    }

    return null;
  }
}
