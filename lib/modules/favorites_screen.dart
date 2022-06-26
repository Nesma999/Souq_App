import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/modules/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import 'cart_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: cubit.getFavoritesModel?.data?.data?.length != 0
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildFavoriteItem(
                          cubit.getFavoritesModel!.data!.data![index].product,
                          context),
                      itemCount: cubit.getFavoritesModel!.data!.data!.length,
                    ),
                  ]),
                )
              : Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 150,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                            child: Text(
                          'No Favorite Products',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                      ]),
                ),
        );
      },
    );
  }

  Widget buildFavoriteItem(FavoriteProductModel model, context) {
    return InkWell(
      onTap: () {
        AppCubit.get(context).getProductDetails(model.id);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 10,
          end: 10.0,
          bottom: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 10.0, top: 5.0),
                  child: Image(
                    image: NetworkImage(model.image),
                    height: 120,
                    width: 120,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'EGP ${model.price}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      if (model.discount != 0)
                        Row(
                          children: [
                            Text(
                              'EGP ${model.oldPrice}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey),
                            ),
                            Spacer(),
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
                            Spacer(),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(children: [
              TextButton(
                onPressed: () {
                  AppCubit.get(context).changeFavorites(model.id);
                },
                child: Row(
                  children: const [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'REMOVE',
                      style: TextStyle(color: defaultColor),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              AppCubit.get(context).carts[model.id]!
                  ? Expanded(
                    child: Row(children: [
                      Container(
                          width: 39,
                          height: 39,
                          decoration: BoxDecoration(
                            color: defaultColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              AppCubit.get(context)
                                  .changeQuantity(productId: model.id,increment: false);
                            },
                            icon: const Icon(Icons.remove),
                            color: Colors.white,
                          )),
                        const Spacer(),
                        const Spacer(),
                      AppCubit.get(context).productsQuantity[model.id] !=null?
                        Text(
                          '${AppCubit.get(context).productsQuantity[model.id]}',
                        ):const CircularProgressIndicator(),
                        const Spacer(),
                        const Spacer(),
                        Container(
                            width: 39,
                            height: 39,
                            decoration: BoxDecoration(
                              color: defaultColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                AppCubit.get(context)
                                    .changeQuantity(productId: model.id);
                              },
                              icon: const Icon(Icons.add),
                              iconSize: 23,
                              color: Colors.white,
                            )),
                      const Spacer(),
                      ]),
                  )
                  : defaultButton(
                      width: 120,
                      height: 40,
                      text: 'ADD TO CART',
                      onPressed: () {
                        AppCubit.get(context).changeCart(model.id);
                      }),
            ]),
                const SizedBox(
                  height: 10.0,
                ),
          ]),
        ),
      ),
    );
  }
}
