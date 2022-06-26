class SearchModel {
  bool? status;
  Data? data;

  SearchModel.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Product>? data;

  Data.fromJson(Map<dynamic, dynamic> json) {
    if (json['data'] != null) {
      data =<Product>[];
      json['data'].forEach((element) {
        data?.add(Product.fromJson(element));
      });
    }
  }
}

class Product{
  late int id;
  late dynamic price;
  late String image;
  late String name;
  late bool inFavorites;
  late bool inCart;

  Product.fromJson(Map<String,dynamic> json){
    id=json['id'];
    price=json['price'];
    image=json['image'];
    name=json['name'];
    inFavorites=json['in_favorites'];
    inCart=json['in_cart'];
  }
}




