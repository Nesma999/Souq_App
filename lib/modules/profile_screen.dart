import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UpdateSuccessAppStates) {
          if (AppCubit.get(context).loginModel!.status!) {
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
        if (state is LogOutSuccessAppStates) {
          if (AppCubit.get(context).logout!.status) {
            defaultFlutterToast(
                msg: AppCubit.get(context).logout!.message,
                state: ToastState.SUCSSES);
          }
        }
      },
      builder: (context, state) {
        double screenHeight = MediaQuery.of(context).size.height;

        var cubit = AppCubit.get(context);
        nameController.text = '${cubit.loginModel?.data?.name}';
        emailController.text = '${cubit.loginModel?.data?.email}';
        phoneController.text = '${cubit.loginModel?.data?.phone}';
        return Scaffold(
          appBar: AppBar(
            title: const Text('MyProfile'),
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
            body:  state is! GetProfileLoadingStates
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.06,
                          color: Colors.grey[200],
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'YOUR PERSONAL DATA',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (state is UpdateLoadingAppStates)
                          const LinearProgressIndicator(),
                        Container(
                          height: screenHeight * 0.6,
                          child: Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.all(20.0),
                              child: Column(
                                children: [
                                  defaultTextField(
                                      controller: nameController,
                                      keyboardType: TextInputType.name,
                                      labelText: 'Name',
                                      prefixIcon: Icons.person_outline,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Name Is Required';
                                        }
                                      }),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  defaultTextField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      labelText: 'Email',
                                      prefixIcon: Icons.email_outlined,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Email Is Required';
                                        }
                                      }),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  defaultTextField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      labelText: 'Phone',
                                      prefixIcon: Icons.phone,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Phone Is Required';
                                        }
                                      }),
                                  const Spacer(),
                                  defaultButton(
                                      text: 'SAVE',
                                      onPressed: () {
                                        if (formKey.currentState != null &&
                                            formKey.currentState!.validate()) {
                                          cubit.updateProfile(
                                              nameController.text,
                                              emailController.text,
                                              phoneController.text);
                                        }
                                      }),
                                  Spacer(),
                                  // state is! LogOutLoagingAppStates
                                  //     ? Container(
                                  //         width: double.infinity,
                                  //         height: screenHeight * 0.06,
                                  //         child: defaultTextButton(
                                  //             onPressed: () {
                                  //               cubit.logOut(context);
                                  //             },
                                  //             text: 'logout'),
                                  //       )
                                  //     : CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }
}
