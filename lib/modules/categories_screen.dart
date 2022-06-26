import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/shared/components/components.dart';

import 'category_products.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: ListView.separated(
            physics: const BouncingScrollPhysics(),
              itemBuilder: (context,index) => buildCategories(cubit.categoryModel!.data.categoryData[index],context),
              separatorBuilder: (context,index)=> Padding(
                padding: const EdgeInsetsDirectional.only(start: 16.0),
                child: Divider(),
              ),
              itemCount: cubit.categoryModel!.data.categoryData.length,
          ),
        );
      },
    );
  }
  Widget buildCategories(CategoryDetailsModel model ,context) => InkWell(
    onTap: (){
      AppCubit.get(context).getProductCategory(model.id);
      navigateTo(context, CategoryProductsScreen(categoryName: model.name,));
    },
    child: Padding(
      padding: const EdgeInsetsDirectional.all(16.0),
      child: Row(children: [
        Image(image: NetworkImage(model.image),
          height: 80.0,
          width: 80.0,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 20.0,),
        Text(model.name,style: TextStyle(fontSize: 18),),
        Spacer(),
        Icon(Icons.arrow_forward_ios_outlined),
      ],),
    ),
  );
}
