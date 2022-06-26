
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/modules/shopLogin/cubit/states.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchStates>
{
  SearchCubit() : super(InitialSearchState());
  
  static SearchCubit get(context) => BlocProvider.of(context);

   SearchModel? searchModel;

  void searchProduct(String text){
    emit(LoadingSearchState());
    DioHelper.postData(
        url: PRODUCT_SEARCH,
        token: token,
        data: {
          'text':text,
        }).then((value) {
      searchModel=SearchModel.fromJson(value.data);
      print(searchModel!.data!.data![0].id);
      print(searchModel!.data!.data![0].name);
      print(searchModel!.data!.data![0].price);
      print(searchModel!.data!.data![0].image);
      emit(SuccessfulSearchState());
    }).catchError((error){
      print(error.toString());
      emit(ErrorSearchState());

    });
  }

}