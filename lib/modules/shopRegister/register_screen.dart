import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/shopLogin/loginScreen.dart';
import 'package:shop_app/modules/shopRegister/cubit/cubit.dart';
import 'package:shop_app/modules/shopRegister/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    var nameController=TextEditingController();
    var emailController=TextEditingController();
    var passwordController=TextEditingController();
    var phoneController=TextEditingController();
    var formKey=GlobalKey<FormState>();
    return BlocProvider(
      create: (context)=> RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
          listener: (context, state) {
            if(state is SuccessfulRegisterState){
              if(state.loginModel.status!){
                CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
                  token=state.loginModel.data!.token;
                  print(token);
                  navigateAndFinish(context, const LoginPage());
                });
              }else{
                defaultFlutterToast(
                    msg:state.loginModel.message! ,
                    state: ToastState.ERROR
                );
              }
            }
          },
        builder: (context,state){
          double screenHeight=MediaQuery.of(context).size.height;
          var cubit=RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.all(16.0),
                  child: SizedBox(
                    height: screenHeight*0.8,
                    child: Form(
                      key:formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REGISTER',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.black),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Register now to browse our hot offers',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.grey,fontSize: 18),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          defaultTextField(
                            prefixIcon: Icons.person_outline,
                            labelText: 'Full Name',
                            keyboardType: TextInputType.name,
                            controller: nameController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Name Is Required';
                              }
                            },
                          ),
                          SizedBox(height:screenHeight*0.03,),
                          defaultTextField(
                            prefixIcon: Icons.email_outlined,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Email Is Required';
                              }
                            },
                          ),
                          SizedBox(height:screenHeight*0.03,),
                          defaultTextField(
                            prefixIcon: Icons.phone_outlined,
                            labelText: 'Phone',
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Phone Is Required';
                              }
                            },
                          ),
                          SizedBox(height:screenHeight*0.03,),
                          defaultTextField(
                            prefixIcon: Icons.lock_outline,
                            labelText: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: cubit.obscureText,
                            suffixIcon: cubit.suffixIcon,
                            suffixIconPressed: () {
                              cubit
                                  .changePasswordVisibility();
                            },
                            controller: passwordController,
                            validator: (value){
                              if(value!.isEmpty){
                                return 'Password Is Required';
                              }
                            },
                          ),

                          const Spacer(),
                          state is! LoadingRegisterState?
                          defaultButton(text: 'REGISTER', onPressed: (){
                            if (formKey.currentState != null && formKey.currentState!.validate()) {
                              cubit.userRegister(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  phone: phoneController.text,
                              );
                            }
                          }):const Center(child: CircularProgressIndicator()),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Already have an account?'),
                              defaultTextButton(
                                onPressed: () {
                                  navigateTo(context, const LoginPage());
                                },
                                text: 'Login',
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
