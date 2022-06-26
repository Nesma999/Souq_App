class ProductDetailsModel{

  bool? status;
  String? message;
  ProductDataModel? data;

  ProductDetailsModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    data= ProductDataModel.fromJson(json['data']);
  }
}

class ProductDataModel{
  int? id;
  dynamic? price;
  dynamic? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
  bool? inFavorites;
  bool? inCart;
  List<String>? images;

  ProductDataModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    oldPrice=json['old_price'];
    discount=json['discount'];
    image=json['image'];
    name=json['name'];
    description=json['description'];
    inFavorites=json['in_favorites'];
    inCart=json['in_cart'];
    images = json['images'].cast<String>();
  }
}