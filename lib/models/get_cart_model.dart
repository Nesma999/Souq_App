class GetCartsModel{
  bool? status;
  String? message;
  GetCartDataModel? data;

  GetCartsModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    data= json['data'] !=null? GetCartDataModel.fromJson(json['data']):null;
  }

}

class GetCartDataModel{
  dynamic? sub_total;
  dynamic? total;
  List<GetCartItemsModel> cart_items =[];

  GetCartDataModel.fromJson(Map<String,dynamic> json){
    sub_total=json['sub_total'];
    total=json['total'];
    json['cart_items'].forEach((element){
      cart_items.add(GetCartItemsModel.fromJson(element));
    });
  }
}

class GetCartItemsModel{
  int? id;
  int? quantity;
  GetCartProductModel? product;

  GetCartItemsModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    quantity=json['quantity'];
    product= json['product']!=null ? GetCartProductModel.fromJson(json['product']) :null;
  }
}

class GetCartProductModel{
  int? id;
  dynamic? price;
  dynamic? oldPrice;
  int? discount;
  String? image;
  String? name;
  List<String>? images;
  String? description;
  bool? inFavorites;
  bool? inCart;

  GetCartProductModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    oldPrice=json['old_price'];
    discount=json['discount'];
    image=json['image'];
    name=json['name'];
    images = json['images'].cast<String>();
    description=json['description'];
    inFavorites=json['in_favorites'];
    inCart=json['in_cart'];
  }
}