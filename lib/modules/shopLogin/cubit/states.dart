import 'package:shop_app/models/login_model.dart';

abstract class LoginStates{}

class InitialLoginState extends LoginStates{}

class LoadingLoginState extends LoginStates{}

class SuccessfulLoginState extends LoginStates{
  final LoginModel loginModel;

  SuccessfulLoginState(this.loginModel);
}

class ErrorLoginState extends LoginStates{

  final String error;
  ErrorLoginState(this.error);
}

class ChangePasswordVisibilityState extends LoginStates{}



