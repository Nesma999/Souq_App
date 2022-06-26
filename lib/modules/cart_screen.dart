import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/models/get_cart_model.dart';
import 'package:shop_app/modules/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        // if (state is ChangeCartsSuccessAppStates) {
        //   defaultFlutterToast(
        //       msg: 'Product Was Removed From Cart', state: ToastState.SUCSSES);
        // }
        if (state is UpdateCartSuccessAppStates) {
          defaultFlutterToast(
              msg: AppCubit.get(context).updateCartModel!.message!,
              state: ToastState.SUCSSES);
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: cubit.getCartsModel!.data!.cart_items.isNotEmpty
              ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.all(16.0),
                      child: Text(
                        'CART SUMMARY',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(16.0),
                        child: Row(
                          children: [
                            const Text(
                              'Subtotal',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text('EGP ${cubit.getCartsModel!.data!.sub_total}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.all(16.0),
                      child: Text(
                        'CART (${cubit.getCartsModel!.data!.cart_items.length})',
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                    state is! GetCartLoadingAppStates
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => buildCartItem(
                                cubit.getCartsModel!.data!.cart_items[index],
                                context),
                            itemCount:
                                cubit.getCartsModel!.data!.cart_items.length,
                          )
                        : const Center(child: CircularProgressIndicator()),
                  ],
                ))
              : Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/logo1.png'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Center(
                            child: Text(
                          'Your Cart is empty!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        )),
                        const SizedBox(
                          height: 25,
                        ),
                        defaultButton(
                            text: 'START SHOPPING',
                            onPressed: () {
                              navigateTo(context, const HomeLayoutScreen());
                            }),
                      ]),
                ),
        );
      },
    );
  }

  Widget buildCartItem(GetCartItemsModel model, context) {
    return InkWell(
      onTap: () {
        AppCubit.get(context).getProductDetails(model.product!.id!);
        navigateTo(context, const ProductDetailsScreen());
      },
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 10, end: 10.0, bottom: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Image(
                  image: NetworkImage(model.product!.image!),
                  height: 120,
                  width: 120,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.product!.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'EGP ${model.product!.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (model.product!.discount! != 0)
                        Row(
                          children: [
                            Text(
                              'EGP ${model.product!.oldPrice}',
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey),
                            ),
                            const Spacer(),
                            Container(
                              color: defaultColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                child: Text(
                                  '-${model.product!.discount}%',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              TextButton(
                  onPressed: () {
                    AppCubit.get(context).changeCart(model.product!.id!);
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
                      )
                    ],
                  )),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              model.quantity! > 1
                  ? Container(
                      width: 37,
                      height: 39,
                      decoration: BoxDecoration(
                        color: defaultColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          AppCubit.get(context).changeQuantity(
                                  productId: model.product!.id!,
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
                    )
                  : Container(
                      width: 37,
                      height: 39,
                      decoration: BoxDecoration(
                        color:defaultColor.shade200,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: IconButton(
                        onPressed: () {
                          defaultFlutterToast(
                                  msg: 'Minimum number allowed is 1',
                                  state: ToastState.WARNING);
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
                '${model.quantity}',
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
                           productId: model.product!.id!);
                    },
                    icon: const Icon(Icons.add),
                    iconSize: 23,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 10,
              ),
            ]),
            const SizedBox(
              height: 5.0,
            ),
          ]),
        ),
      ),
    );
  }
}
