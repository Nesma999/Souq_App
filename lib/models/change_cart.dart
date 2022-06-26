class ChangeCartModel{
  bool? status;
  String? message;
  CartDataModel? data;

  ChangeCartModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    data= json['data']!=null? CartDataModel.fromJson(json['data']) :null;
  }

}

class CartDataModel{
  int? id;
  int? quantity;
  CartProductModel? product;

  CartDataModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    quantity=json['quantity'];
    product= CartProductModel.fromJson(json['product']);
  }
}

class CartProductModel{
  int? id;
  dynamic? price;
  dynamic? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  CartProductModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    oldPrice=json['old_price'];
    discount=json['discount'];
    image=json['image'];
    name=json['name'];
    description=json['description'];
  }
}