import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    var currentPasswordController=TextEditingController();
    var passwordController=TextEditingController();

    var formKey=GlobalKey<FormState>();
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is ChangePasswordSuccessAppStates){
          if(AppCubit.get(context).loginModel!.status!){
            defaultFlutterToast(
                msg: AppCubit.get(context).loginModel!.message!,
                state: ToastState.SUCSSES);
          }
          if (!AppCubit.get(context).loginModel!.status!) {
            defaultFlutterToast(
                msg: AppCubit.get(context).loginModel!.message!,
                state: ToastState.ERROR);
          }
        }
      },
      builder: (context,state){
        double screenHeight=MediaQuery.of(context).size.height;
        double screenWidth=MediaQuery.of(context).size.width;
        var cubit=AppCubit.get(context);
        return  Scaffold(
          appBar: AppBar(
            title: const Text('Change Password'),
            actions:  [
              IconButton(
                  onPressed: (){
                    navigateTo(context,const SearchScreen());
                  },
                  icon: const Icon(Icons.search)
              ),
              IconButton(
                  onPressed: (){
                    navigateTo(context,const SearchScreen());
                  },
                  icon: const Icon(Icons.shopping_cart)
              ),
            ],
          ),
          body: Column(children: [
            Container(
              width: double.infinity,
              height: screenHeight*0.06,
              color: Colors.grey[200],
              child: const Padding(
                padding: EdgeInsets.all(14.0),
                child: Text('PASSWORD',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Form(
              key: formKey,
              child:Padding(
                padding: const EdgeInsetsDirectional.all(20.0),
                child: Column(
                  children: [
                    defaultTextField(
                        controller:currentPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Current Password',
                        suffixIcon:cubit.suffixIcon ,
                        prefixIcon: Icons.lock_outline,
                        obscureText: cubit.obscureText,
                        suffixIconPressed: (){
                          cubit.changeCurrentPasswordVisibility();
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Current Password Is Required';
                          }
                        }
                    ),
                    SizedBox(height: screenHeight*0.03,),
                    defaultTextField(
                        controller:passwordController ,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: 'Password',
                        suffixIcon:cubit.suffixConfirmIcon ,
                        prefixIcon: Icons.lock_outline,
                        obscureText: cubit.obscureConfirmText,
                        suffixIconPressed: (){
                          cubit.changeConfirmPasswordVisibility();
                        },
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Password Is Required';
                          }
                        }
                    ),
                    SizedBox(height: screenHeight*0.06,),
                    state is! ChangePasswordLoadingAppStates?
                    defaultButton(text: 'CHANGE PASSWORD', onPressed: (){
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()){
                        cubit.changePassword(currentPasswordController.text, passwordController.text);
                      }
                    }):const CircularProgressIndicator(),
                  ],),
              ) ,
            ),

          ],),
        );
      },
    );
  }
}
