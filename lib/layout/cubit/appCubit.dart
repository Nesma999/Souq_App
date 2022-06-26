import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/category_product_model.dart';
import 'package:shop_app/models/change_cart.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/get_cart_model.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/logout_model.dart';
import 'package:shop_app/models/product_detail_model.dart';
import 'package:shop_app/models/profile_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/models/update_cart_model.dart';
import 'package:shop_app/modules/categories_screen.dart';
import 'package:shop_app/modules/category_products.dart';
import 'package:shop_app/modules/products_screen.dart';
import 'package:shop_app/modules/profile_screen.dart';
import 'package:shop_app/modules/favorites_screen.dart';
import 'package:shop_app/modules/shopLogin/loginScreen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialAppStates());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = const [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];
  List<String> appBar = [
    'Home',
    'Categories',
    'Favorites',
    'Profile',
  ];
  int currentIndex = 0;

  void changeBottomNavigation(int index) {
    currentIndex = index;
    emit(ChangeBottomNavigationAppStates());
  }

  HomeModel? homeModel;

  Map<int, bool> favorites = {};
  Map<int, bool> carts = {};

  bool isGetData = false;

  void getHomeData() {
    emit(HomeDataLoadingAppStates());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      isGetData = true;
      homeModel = HomeModel.fromJson(value.data);
      homeModel?.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      homeModel?.data.products.forEach((element) {
        carts.addAll({element.id: element.inCart});
      });
      emit(HomeDataSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(HomeDataErrorAppStates());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ChangeFavoritesAppStates());
    DioHelper.postData(
        url: FAVORITES,
        token: token,
        data: {'product_id': productId}).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavorites();
      }
      emit(ChangeFavoritesSuccessAppStates());
    }).catchError((erorr) {
      favorites[productId] = !favorites[productId]!;
      print(erorr.toString());
      emit(ChangeFavoritesErrorAppStates());
    });
  }

  GetFavoritesModel? getFavoritesModel;

  void getFavorites() {
    emit(GetFavoritesLoadingAppStates());
    DioHelper.getData(url: FAVORITES, token: token).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      emit(GetFavoritesSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavoritesErrorAppStates());
    });
  }

  CategoryModel? categoryModel;

  void getCategories() {
    DioHelper.getData(
      url: CATEGORY,
      token: token,
    ).then((value) {
      categoryModel = CategoryModel.fromJson(value.data);
      emit(CategoryDataSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(CategoryDataErrorAppStates());
    });
  }

  LoginModel? loginModel;

  void getProfileData() {
    emit(GetProfileLoadingStates());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      loginModel = LoginModel.fromJason(value.data);
      emit(GetProfileSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetProfileErrorAppStates());
    });
  }

  void updateProfile(String name, String email, String phone) {
    emit(UpdateLoadingAppStates());
    DioHelper.updateData(url: UPDATE, token: token, data: {
      'email': email,
      'name': name,
      'phone': phone,
    }).then((value) {
      loginModel = LoginModel.fromJason(value.data);
      // getProfileData();
      emit(UpdateSuccessAppStates());
    }).catchError((error) {
      emit(UpdateErrorAppStates());
    });
  }

  LogOutModel? logout;

  void logOut(context) {
    emit(LogOutLoagingAppStates());
    DioHelper.postData(url: LOGOUT, token: token, data: {}).then((value) {
      logout = LogOutModel.fromJson(value.data);
      CacheHelper.removeData(key: 'token').then((value) {
        if (value) {
          token = null;
          navigateAndFinish(context, const LoginPage());
        }
      });
      emit(LogOutSuccessAppStates());
    }).catchError((erorr) {
      print(erorr.toString());
      emit(LogOutErrorAppStates());
    });
  }

  CategoryProductsModel? categoryProductsModel;

  void getProductCategory(int categoryId) {
    emit(GetCategoryProductLoadingAppStates());
    DioHelper.getData(url: CATEGORY_PRODUCT, token: token, query: {
      'category_id': categoryId,
    }).then((value) {
      categoryProductsModel = CategoryProductsModel.fromJson(value.data);
      categoryProductsModel!.data.productData.forEach((element) {});
      print(categoryProductsModel!.data.productData[0].id);
      print(categoryProductsModel!.status);
      emit(GetCategoryProductSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetCategoryProductErrorAppStates());
    });
  }

  IconData suffixIcon = Icons.visibility;
  bool obscureText = true;

  void changeCurrentPasswordVisibility() {
    obscureText = !obscureText;
    obscureText
        ? suffixIcon = Icons.visibility
        : suffixIcon = Icons.visibility_off;
    emit(ChangeCurrentPasswordVisibilityState());
  }

  IconData suffixConfirmIcon = Icons.visibility;
  bool obscureConfirmText = true;

  void changeConfirmPasswordVisibility() {
    obscureConfirmText = !obscureConfirmText;
    obscureConfirmText
        ? suffixConfirmIcon = Icons.visibility
        : suffixConfirmIcon = Icons.visibility_off;
    emit(ChangeConfirmPasswordVisibilityState());
  }

  void changePassword(String currentPass, String password) {
    emit(ChangePasswordLoadingAppStates());
    DioHelper.postData(url: CHANGE_PASS, token: token, data: {
      'current_password': currentPass,
      'new_password': password,
    }).then((value) {
      loginModel = LoginModel.fromJason(value.data);
      print(loginModel!.message);
      emit(ChangePasswordSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(ChangePasswordErrorAppStates());
    });
  }

  ProductDetailsModel? productDetailsModel;
  void getProductDetails(int productId) {
    emit(GetProductDetailLoadingStates());
    DioHelper.getData(
      url: 'products/$productId',
    ).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(GetProductDetailSuccessAppStates());
    }).catchError((error) {
      emit(GetProductDetailErrorAppStates());
    });
  }

  ChangeCartModel? changeCartModel;
  void changeCart(int productId) {
    carts[productId] = !carts[productId]!;
    DioHelper.postData(url: CARTS, token: token, data: {
      'product_id': productId,
    }).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      if (!changeCartModel!.status!) {
        carts[productId] = !carts[productId]!;
      } else {
        getCart();
      }
      print(changeCartModel!.message);
      emit(ChangeCartsSuccessAppStates());
    }).catchError((error) {
      carts[productId] = !carts[productId]!;
      print(error.toString());
      emit(ChangeCartsErrorAppStates());
    });
  }

  GetCartsModel? getCartsModel;

  var productsQuantity={};
  var productCartId={};
  void getCart() {
    emit(GetCartLoadingAppStates());
    DioHelper.getData(url: CARTS, token: token).then((value) {
      getCartsModel = GetCartsModel.fromJson(value.data);
      getCartsModel!.data!.cart_items.forEach((element) {
        productsQuantity[element.product!.id] = element.quantity;
        productCartId[element.product!.id]=element.id;
      });
      emit(GetCartSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(GetCartErrorAppStates());
    });
  }

  UpdateCartModel? updateCartModel;
  void changeQuantity({required int productId , bool increment=true}) {
    emit(UpdateCartLoadingAppStates());
    int quantity = productsQuantity[productId];
    int cartId= productCartId[productId];
    if (increment && quantity >= 0) {
      quantity++;
    } else if (!increment && quantity > 1) {
      quantity--;
    }else if (!increment && quantity == 1) {
      quantity--;
      changeCart(productId);
      return;
    }
    DioHelper.updateData(
      url: 'carts/$cartId',
      data: {
        'quantity': quantity,
      },
      token: token,
    ).then((value) {
      updateCartModel=UpdateCartModel.fromJson(value.data);
      getCart();
      emit(UpdateCartSuccessAppStates());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateCartErrorAppStates());
    });
  }
}
