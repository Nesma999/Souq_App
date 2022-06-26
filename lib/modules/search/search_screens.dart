import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/appCubit.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';

import '../product_details_screen.dart';
import 'cubit/states.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var searchController = TextEditingController();
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsetsDirectional.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      defaultTextField(
                        prefixIcon: Icons.search,
                        labelText: 'Search',
                        keyboardType: TextInputType.text,
                        controller: searchController,
                        onSaved: (String text) {
                          cubit.searchProduct(text);
                        },
                        validator: (value) {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      if (state is LoadingSearchState)
                        const LinearProgressIndicator(),
                      if (state is SuccessfulSearchState)
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => buildListItem(cubit.searchModel!.data!.data![index],context),
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: cubit.searchModel!.data!.data!.length,
                          ),
                        )
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
Widget buildListItem(Product model,context){
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
                height: 100,
                width: 100,
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
                      const SizedBox(
                        width: 10,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            AppCubit.get(context).changeFavorites(model.id);
                          },
                          icon: AppCubit.get(context).favorites[model.id]!
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
}
