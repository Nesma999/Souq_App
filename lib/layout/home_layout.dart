import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/cart_screen.dart';
import 'package:shop_app/modules/change_password.dart';
import 'package:shop_app/modules/profile_screen.dart';
import 'package:shop_app/modules/shopLogin/loginScreen.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AppCubit>(context)
        ..getHomeData()
        ..getCategories()
        ..getFavorites()
        ..getProfileData()
        ..getCart(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is LogOutSuccessAppStates) {
            if (AppCubit.get(context).logout!.status) {
              defaultFlutterToast(
                  msg: AppCubit.get(context).logout!.message,
                  state: ToastState.SUCSSES);
            }
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return
            cubit.isGetData
              ? Scaffold(
                  appBar: AppBar(
                    title: Text('SouQ'),
                    actions: [
                      IconButton(
                          onPressed: () {
                            navigateTo(context, const SearchScreen());
                          },
                          icon: const Icon(Icons.search)),
                      Stack(alignment: AlignmentDirectional.topEnd, children: [
                        IconButton(
                          onPressed: () {
                            navigateTo(context, const CartScreen());
                          },
                          icon: const Icon(Icons.shopping_cart),
                        ),
                        Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: defaultColor),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 6, top: 2),
                              child: Text(
                                '${cubit.getCartsModel!.data!.cart_items.length}',
                                style: TextStyle(color: Colors.white),
                                //textAlign: TextAlign.center,
                              ),
                            )),
                      ]),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: cubit.currentIndex,
                    onTap: (index) {
                      cubit.changeBottomNavigation(index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.category), label: 'Categories'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite), label: 'Favorites'),
                      // BottomNavigationBarItem(
                      //     icon: Icon(Icons.person), label: 'Profile'),
                    ],
                  ),
                  body: cubit.screens[cubit.currentIndex],
                  drawer: Drawer(
                    child: myDrawer(cubit.loginModel!.data!, state, context),
                  ),
                )
              : Scaffold(
                  body: Padding(
                    padding: const EdgeInsetsDirectional.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Image(
                          image: AssetImage('assets/images/logo.jpeg'),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Text(
                          'LOADING...',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        LinearProgressIndicator(),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget myDrawer(UserData model, state, context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: defaultColor,
          child: Padding(
            padding: EdgeInsetsDirectional.only(
                start: 10.0, end: 10.0, top: screenHeight * 0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Text(
                  model.email!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        ListTile(
          onTap: () {
            navigateTo(context, const ProfileScreen());
          },
          title: const Text(
            'Profile',
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          leading: Icon(Icons.person_outline),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        ListTile(
          onTap: () {
            navigateTo(context, const ChangePasswordScreen());
          },
          title: const Text(
            'Change Password',
          ),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          leading: const Icon(Icons.lock_outline),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        const ListTile(
          title: Text(
            'Settings',
          ),
          trailing: Icon(Icons.arrow_forward_ios_outlined),
          leading: Icon(Icons.settings),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        state is! LogOutLoagingAppStates
            ? ListTile(
                onTap: () {
                  AppCubit.get(context).logOut(context);
                },
                title: const Text(
                  'LogOut',
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
                leading: Icon(Icons.logout_outlined),
              )
            : const CircularProgressIndicator(),
      ],
    );
  }
}
