import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/search/search_screens.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'cart_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var control = PageController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        var cubit = AppCubit.get(context);
        return Scaffold(
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
          body: cubit.productDetailsModel != null &&
                  state is! GetProductDetailLoadingStates
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.25,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        width: double.infinity,
                        child: PageView.builder(
                          controller: control,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => Container(
                            child: Image(
                              image: NetworkImage(cubit
                                  .productDetailsModel!.data!.images![index]),
                            ),
                          ),
                          itemCount:
                              cubit.productDetailsModel!.data!.images!.length,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SmoothPageIndicator(
                        controller: control,
                        count: cubit.productDetailsModel!.data!.images!.length,
                        effect: const WormEffect(
                            activeDotColor: defaultColor,
                            dotColor: Color.fromRGBO(230, 179, 230, 1),
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            spacing: 5.0),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey[100]),
                                child: IconButton(
                                    onPressed: () {
                                      AppCubit.get(context).changeFavorites(
                                          cubit.productDetailsModel!.data!.id!);
                                    },
                                    icon: AppCubit.get(context).favorites[cubit
                                            .productDetailsModel!.data!.id]!
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
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                cubit.productDetailsModel!.data!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'EGP ${cubit.productDetailsModel!.data!.price}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    width: screenWidth / 15,
                                  ),
                                  if (cubit.productDetailsModel!.data!
                                          .discount !=
                                      0)
                                    Text(
                                      'EGP ${cubit.productDetailsModel!.data!.oldPrice}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  SizedBox(
                                    width: screenWidth / 15,
                                  ),
                                  if (cubit.productDetailsModel!.data!
                                          .discount !=
                                      0)
                                    Container(
                                      color: defaultColor,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 4.0),
                                        child: Text(
                                          '-${cubit.productDetailsModel!.data!.discount}%',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  //Spacer(),
                                ],
                              ),
                            ]),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        color: Colors.grey[100],
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'PRODUCT DETAILS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Divider(),
                            Text(
                              cubit.productDetailsModel!.data!.description!,
                              style: TextStyle(height: 1.5),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          persistentFooterButtons: [
            cubit.productDetailsModel != null &&
                    state is! GetProductDetailLoadingStates
                ? AppCubit.get(context)
                            .carts[cubit.productDetailsModel?.data!.id]! &&
                        cubit.productDetailsModel != null
                    ? Row(children: [
                        Container(
                          width: 38,
                          height: 39,
                          decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              AppCubit.get(context).changeQuantity(
                                  productId:
                                      cubit.productDetailsModel!.data!.id!,
                                  increment: false);
                            },
                            icon: const Icon(
                              Icons.remove,
                              size: 25,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        AppCubit.get(context).productsQuantity[
                                    cubit.productDetailsModel!.data!.id] !=
                                null
                            ?
                        Text(
                                '${AppCubit.get(context).productsQuantity[cubit.productDetailsModel!.data!.id]}',
                              )
                            : const CircularProgressIndicator(),
                        const Spacer(),
                        Container(
                            width: 38,
                            height: 39,
                            decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                AppCubit.get(context).changeQuantity(
                                    productId:
                                        cubit.productDetailsModel!.data!.id!);
                              },
                              icon: const Icon(Icons.add),
                              iconSize: 23,
                              color: Colors.white,
                            )),
                      ])
                    : defaultButton(
                        text: 'ADD TO CART',
                        onPressed: () {
                          AppCubit.get(context)
                              .changeCart(cubit.productDetailsModel!.data!.id!);
                        })
                : const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
