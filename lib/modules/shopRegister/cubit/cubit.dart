
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/shopRegister/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(InitialRegisterState());
  
  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData suffixIcon = Icons.visibility;
  bool obscureText = true;

  void changePasswordVisibility(){
    obscureText = !obscureText;
    obscureText ? suffixIcon = Icons.visibility : suffixIcon = Icons.visibility_off ;
    emit(ChangeRegisterPasswordVisibilityState());
  }
   LoginModel? loginModel;
void userRegister({
  required String name,
  required String email,
  required String password,
  required String phone,
}){
    emit(LoadingRegisterState());
  DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone
      },
    lang: 'en'
  ).then((value){
    loginModel=LoginModel.fromJason(value.data);
    print(loginModel!.message);
    emit(SuccessfulRegisterState(loginModel!));
  }).catchError((onError){
    print(onError.toString());
    emit(ErrorRegisterState(onError.toString()));
  });
}

}