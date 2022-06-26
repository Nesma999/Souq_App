class GetFavoritesModel{
   bool? status;
   FavoriteDataModel? data;

  GetFavoritesModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    data=FavoriteDataModel.fromJson(json['data']);
  }
}

class FavoriteDataModel{
  List<FavoriteModel>? data ;

  FavoriteDataModel.fromJson(Map<String,dynamic> json){

    if(json['data'] !=null) {
      data =<FavoriteModel>[];
      json['data'].forEach((element) {
        data!.add(FavoriteModel.fromJson(element));
      });
    }
  }
}

class FavoriteModel{
   late FavoriteProductModel product;

  FavoriteModel.fromJson(Map<String,dynamic> json){
    product=(json['product'] !=null ? FavoriteProductModel.fromJson(json['product']) :null)!;
  }
}


class FavoriteProductModel{
   late int id;
   late dynamic price;
   late dynamic oldPrice;
   late int discount;
   late String image;
   late String name;

  FavoriteProductModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    oldPrice=json['old_price'];
    discount=json['discount'];
    image=json['image'];
    name=json['name'];
  }
}