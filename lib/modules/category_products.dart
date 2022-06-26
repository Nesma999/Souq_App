import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/category_product_model.dart';
import 'package:shop_app/modules/product_details_screen.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import 'cart_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;
    CategoryProductsScreen({ required this.categoryName,});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:Text('SouQ'),
            actions:  [
              IconButton(
                  onPressed: (){
                    navigateTo(context,const SearchScreen());
                  },
                  icon: const Icon(Icons.search)
              ),
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
                      padding:
                      const EdgeInsetsDirectional.only(start: 6, top: 2),
                      child: Text(
                        '${cubit.getCartsModel!.data!.cart_items.length}',
                        style: TextStyle(color: Colors.white),
                        //textAlign: TextAlign.center,
                      ),
                    )),
              ]),
            ],
          ),
          body: state is!GetCategoryProductLoadingAppStates?
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(categoryName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.grey[100],
                child:GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1 / 2.5,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  children: List.generate(
                    cubit.categoryProductsModel!.data.productData.length,
                        (index) => buildProductsItem(cubit.categoryProductsModel!.data.productData[index] ,context),
                  ),
                ),
              ),

            ],)):const Center(child: CircularProgressIndicator(),
          ),
        );
      },

    );
  }
  Widget buildProductsItem(CategoryProductDetails model,context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        AppCubit.get(context).getProductDetails(model.id!);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(alignment: AlignmentDirectional.topEnd, children: [
              Image(
                image: NetworkImage(model.image!),
                height: screenHeight * 0.25,
                width: double.infinity,
              ),
              if (model.discount != 0)
                Container(
                  color: defaultColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 5.0),
                    child: Text(
                      '-${model.discount}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 130, top: 175),
                child: IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeFavorites(model.id!);
                    },
                    icon: AppCubit
                        .get(context)
                        .favorites[model.id!]!
                        ? const Icon(
                      Icons.favorite,
                      color: defaultColor,
                      size: 30,
                    )
                        : const Icon(
                      Icons.favorite_border,
                      color: defaultColor,
                      size: 30,
                    )),
              ),
            ]),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (model.oldPrice <= 1000)
                    Row(
                      children: [
                        Text(
                          'EGP ${model.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16
                            //color: defaultColor,
                          ),
                        ),
                        Spacer(),
                        if (model.discount != 0)
                          Text(
                            'EGP ${model.oldPrice}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                  if (model.oldPrice >= 1000)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EGP ${model.price}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16
                            //color: defaultColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (model.discount != 0)
                          Text(
                            'EGP ${model.oldPrice}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                                decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                  AppCubit
                      .get(context)
                      .carts[model.id!]!
                      ? Row(children: [
                    Container(
                      width: 37,
                      height: 39,
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeQuantity(
                              productId: model.id!,
                              increment: false);
                        },
                        icon: const Icon(
                          Icons.minimize_outlined,
                          size: 25,
                        ),
                        padding: const EdgeInsets.only(bottom: 18),
                        //iconSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${AppCubit
                          .get(context)
                          .productsQuantity[model.id!]}',
                    ),
                    const Spacer(),
                    Container(
                        width: 37,
                        height: 39,
                        decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).changeQuantity(
                                productId: model.id!);
                          },
                          icon: const Icon(Icons.add),
                          iconSize: 23,
                          color: Colors.white,
                        )),
                  ])
                      : defaultButton(
                      text: 'ADD TO CART',
                      onPressed: () {
                        AppCubit.get(context).changeCart(model.id!);
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
