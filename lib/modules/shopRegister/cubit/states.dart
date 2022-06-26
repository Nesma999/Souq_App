import 'package:shop_app/models/login_model.dart';

abstract class RegisterStates{}

class InitialRegisterState extends RegisterStates{}

class LoadingRegisterState extends RegisterStates{}

class SuccessfulRegisterState extends RegisterStates{
  final LoginModel loginModel;

  SuccessfulRegisterState(this.loginModel);
}

class ErrorRegisterState extends RegisterStates{

  final String error;
  ErrorRegisterState(this.error);
}

class ChangeRegisterPasswordVisibilityState extends RegisterStates{}



