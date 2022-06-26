import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/profile_screen.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var emailController = TextEditingController();
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if(state is UpdateSuccessAppStates){
          if(AppCubit.get(context).loginModel!.status!){
            defaultFlutterToast(msg: AppCubit.get(context).loginModel!.message!, state: ToastState.SUCSSES);
            //Navigator.pop(context);
          }
          if(!AppCubit.get(context).loginModel!.status!){
            defaultFlutterToast(msg: AppCubit.get(context).loginModel!.message!, state: ToastState.ERROR);
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
              // leading:IconButton(
              //     onPressed: () {
              //       navigateAndFinish(context, HomeLayoutScreen());
              //     },
              //     icon: const Icon(Icons.arrow_back)),
              title: Text('My Profile'),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, const SearchScreen());
                    },
                    icon: const Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      navigateTo(context, const SearchScreen());
                    },
                    icon: const Icon(Icons.shopping_cart)),
              ],
            ),
            body: cubit.loginModel !=null && state is! GetProfileLoadingStates
                ? Column(
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
                      if(state is UpdateLoadingAppStates)
                        const LinearProgressIndicator(),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.all(20.0),
                          child: Column(
                            children: [
                              defaultUpdateTextField(
                                  controller: nameController,
                                  keyboardType: TextInputType.name,
                                  labelText: 'Name',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {}),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              defaultUpdateTextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  labelText: 'Email',
                                  prefixIcon: Icons.email_outlined,
                                  validator: (value) {}),
                              SizedBox(
                                height: screenHeight * 0.03,
                              ),
                              defaultUpdateTextField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  labelText: 'Phone',
                                  prefixIcon: Icons.phone,
                                  validator: (value) {}),
                              SizedBox(
                                height: screenHeight * 0.06,
                              ),

                              defaultButton(text: 'SAVE', onPressed: () {
                                cubit.updateProfile( nameController.text, emailController.text , phoneController.text);
                              })
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }
}
