class LogOutModel{
  late bool status;
  late String message;
  late  LogOutDataModel data;

  LogOutModel.fromJson(Map<String,dynamic> json){
    status=json['status'];
    message=json['message'];
    data=LogOutDataModel.fromJson(json['data']);
  }
}

class LogOutDataModel{
  late int id;
  late String token;

  LogOutDataModel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    token=json['token'];
  }
}