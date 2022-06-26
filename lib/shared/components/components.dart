import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/models/get_favorites_model.dart';
import 'package:shop_app/modules/product_details_screen.dart';

import 'constants.dart';

Widget defaultTextField({
  required IconData prefixIcon,
  required String labelText,
  required TextInputType keyboardType,
  required TextEditingController controller,
  required String? Function (String? val) validator,
  IconData? suffixIcon,
  bool obscureText = false,
  Function? suffixIconPressed,
  onSaved,
  onChange,
}){
  return TextFormField(
    obscureText:obscureText ,
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixIcon),
      suffixIcon: IconButton(
        icon: Icon(suffixIcon),
        onPressed: () {
          suffixIconPressed!();
        },
      ),
      labelText: labelText,
      border: const OutlineInputBorder(),
    ) ,
    validator: validator,
    onFieldSubmitted: onSaved,
    onChanged: onChange,
  );
}

Widget defaultButton({
  required String text,
  required Function onPressed,
  double width=double.infinity,
  double height=50,
}){
  return  Container(
    width: width,
    height: height,
    child: ElevatedButton(
      style: TextButton.styleFrom(
      ),
      onPressed: (){
        onPressed();
      } ,
      child: Text(text.toUpperCase(),),
    ),
  );
}

Widget defaultTextButton({
  required Function onPressed,
  required String text,
}){
  return TextButton(
    onPressed: (){
      onPressed();
    },
    child: Text(text.toUpperCase()),
  );
}

Future navigateAndFinish(context, widget)
{
  return  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => widget,
      ),
          (route) => false,
  );
}

Future navigateTo(context, widget)
{
  return  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}

Future defaultFlutterToast({
  required String msg,
  required ToastState state,
}){
  return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: showToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0
  );
}
enum ToastState{SUCSSES,ERROR,WARNING}

Color showToastColor(ToastState state){
  Color color;
  switch(state) {
    case ToastState.SUCSSES:
      color = defaultColor;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;

  }
  return color;

}

Widget defaultUpdateTextField({
  required TextEditingController controller,
  required String labelText,
   required IconData prefixIcon,
  IconData? suffixIcon,
  Function? onPressedIcon,
  required String? Function(String ? value) validator,
  required TextInputType keyboardType,
}){
  return TextFormField(
    controller: controller,
    keyboardType:keyboardType ,
    decoration:  InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(prefixIcon),
      suffixIcon: IconButton(
        onPressed: (){
          onPressedIcon!();
        },
        icon: Icon(suffixIcon),
      )
    ),
    validator: validator,
  );
}


Widget buildProductListItem(model,context,{isOldPrice=true}){
  return InkWell(
    onTap: (){
      AppCubit.get(context).getProductDetails(model.id);
      navigateTo(context, const ProductDetailsScreen());
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(alignment: AlignmentDirectional.topEnd, children: [
            Image(
              image: NetworkImage(model.image),
              height: 120,
              width: 120,
            ),
            if (model.discount != 0 && isOldPrice)
              Container(
                color: defaultColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  child:
                  Text(
                    '-${model.discount}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ]),
          const SizedBox(
            width: 20,
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'EGP ${model.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold
                        //color: defaultColor,
                      ),
                    ),
                    const Spacer(),
                    if (model.discount != 0 && isOldPrice)
                      Text(
                        'EGP ${model.oldPrice}',
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          AppCubit.get(context)
                              .changeFavorites(model.id!);
                        },
                        icon:
                        AppCubit.get(context).favorites[model.id]!
                            ? const Icon(
                          Icons.favorite,
                          color: defaultColor,
                        )
                            : const Icon(
                          Icons.favorite_border,
                          color: defaultColor,
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

