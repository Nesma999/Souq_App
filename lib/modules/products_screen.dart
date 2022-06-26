import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/category_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/favorites_screen.dart';
import 'package:shop_app/modules/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import 'category_products.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesSuccessAppStates) {
          if (!AppCubit.get(context).changeFavoritesModel!.status) {
            defaultFlutterToast(
                msg: AppCubit.get(context).changeFavoritesModel!.message,
                state: ToastState.ERROR);
          }
        }
        if (state is ChangeCartsSuccessAppStates) {
          defaultFlutterToast(
              msg: AppCubit.get(context).changeCartModel!.message!,
              state: ToastState.SUCSSES);
        }
        if (state is UpdateCartSuccessAppStates) {
          defaultFlutterToast(
              msg: AppCubit.get(context).updateCartModel!.message!,
              state: ToastState.SUCSSES);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: cubit.homeModel != null && cubit.categoryModel != null
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        items: cubit.homeModel?.data.banners
                            .map((e) => Image(
                                  image: NetworkImage(e.image),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ))
                            .toList(),
                        options: CarouselOptions(
                          height: 200.0,
                          autoPlay: true,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          initialPage: 0,
                          reverse: false,
                          scrollDirection: Axis.horizontal,
                          viewportFraction: 1.0,
                          autoPlayInterval: const Duration(seconds: 3),
                          enableInfiniteScroll: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Categories',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 100.0,
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    buildCategoryItem(
                                        cubit.categoryModel!.data
                                            .categoryData[index],
                                        context),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 10.0,
                                ),
                                itemCount: 5,
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Text(
                              'New Products',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        color: Colors.grey[100],
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1 / 2.7,
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          children: List.generate(
                            cubit.homeModel!.data.products.length,
                            (index) => buildProductsItem(
                                cubit.homeModel!.data.products[index], context,state),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildProductsItem(ProductModel model, context,state) {
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        AppCubit.get(context).getProductDetails(model.id);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(alignment: AlignmentDirectional.topEnd, children: [
              Image(
                image: NetworkImage(model.image),
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
                padding: const EdgeInsetsDirectional.only(end: 130, top: 175,),
                child: IconButton(
                    onPressed: () {
                      AppCubit.get(context).changeFavorites(model.id);
                    },
                    icon: AppCubit.get(context).favorites[model.id]!
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
              padding: const EdgeInsetsDirectional.only(start: 10.0, end: 10.0,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
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
                        SizedBox(height: 40,)
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
                        if (model.discount == 0)
                          SizedBox(height: 16,),
                      ],
                    ),
                  const SizedBox(
                    height: 70,
                  ),
                  AppCubit.get(context).carts[model.id]!
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
                                    productId: model.id,
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
                            '${AppCubit.get(context).productsQuantity[model.id]}',
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
                                      productId: model.id);
                                },
                                icon: const Icon(Icons.add),
                                iconSize: 23,
                                color: Colors.white,
                              )),
                        ])
                      :defaultButton(
                      text: 'ADD TO CART',
                      onPressed: () {
                        AppCubit.get(context).changeCart(model.id);
                      }),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(CategoryDetailsModel model, context) => InkWell(
        onTap: () {
          AppCubit.get(context).getProductCategory(model.id);
          navigateTo(
              context,
              CategoryProductsScreen(
                categoryName: model.name,
              ));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Container(
                width: 100.0,
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  model.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ),
      );
}
