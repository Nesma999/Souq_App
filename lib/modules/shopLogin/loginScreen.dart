import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/shopRegister/register_screen.dart';
import 'package:shop_app/modules/shopLogin/cubit/cubit.dart';
import 'package:shop_app/modules/shopLogin/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is SuccessfulLoginState){
            if(state.loginModel.status!){
              CacheHelper.saveData(key: 'token', value: state.loginModel.data!.token).then((value) {
                token=state.loginModel.data!.token;
                print(token);
                AppCubit.get(context).currentIndex=0;
                navigateAndFinish(context, const HomeLayoutScreen());
              });
            }else{
              defaultFlutterToast(
                  msg:state.loginModel.message! ,
                  state: ToastState.ERROR
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        'Login now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Form(
                        key:formKey,
                        child: Column(children: [
                          defaultTextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              labelText: 'Email Address',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email Address is required';
                                }
                              }),
                          const SizedBox(
                            height: 15.0,
                          ),
                          defaultTextField(
                              obscureText: LoginCubit.get(context).obscureText,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icons.lock_outline,
                              labelText: 'Password',
                              suffixIcon: LoginCubit.get(context).suffixIcon,
                              suffixIconPressed: () {
                                LoginCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }
                              }),
                          const SizedBox(
                            height: 25.0,
                          ),
                          state is! LoadingLoginState?
                          defaultButton(
                              onPressed: () {
                                if (formKey.currentState != null && formKey.currentState!.validate()){
                                  LoginCubit.get(context).userLogin(email: emailController.text, password: passwordController.text);

                                };
                              },
                              text: 'login'
                          ):const Center(child: CircularProgressIndicator()),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Don\'t have an account?'),
                              defaultTextButton(
                                onPressed: () {
                                  navigateTo(context, const RegisterPage());
                                },
                                text: 'register',
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ],
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
