
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/shopLogin/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit() : super(InitialLoginState());
  
  static LoginCubit get(context) => BlocProvider.of(context);

  IconData suffixIcon = Icons.visibility;
  bool obscureText = true;

  void changePasswordVisibility(){
    obscureText = !obscureText;
    obscureText ? suffixIcon = Icons.visibility : suffixIcon = Icons.visibility_off ;
    emit(ChangePasswordVisibilityState());
  }
  late LoginModel loginModel;
void userLogin({
  required String email,
  required String password,
}){
    emit(LoadingLoginState());
  DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password
      },
    lang: 'en'
  ).then((value){
    loginModel=LoginModel.fromJason(value.data);
    emit(SuccessfulLoginState(loginModel));
  }).catchError((onError){
    print(onError.toString());
    emit(ErrorLoginState(onError.toString()));
  });
}

}