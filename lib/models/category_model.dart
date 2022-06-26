class CategoryModel{
  late bool status;
  late CategoryDataModel data;
  CategoryModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    data = CategoryDataModel.fromJson(json['data']);
  }
}

class CategoryDataModel{
  late int currentPage;
  List<CategoryDetailsModel> categoryData=[];

  CategoryDataModel.fromJson(Map<String,dynamic> json){
    currentPage=json['current_page'];
    json['data'].forEach((element){
      categoryData.add( CategoryDetailsModel.fromJson(element));
    });
  }

}

class CategoryDetailsModel{
  late int id;
  late String name;
  late String image;

  CategoryDetailsModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    name=json['name'];
    image=json['image'];
  }
}