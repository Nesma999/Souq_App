class LoginModel{
    bool? status;
   String? message;
   UserData? data;

  LoginModel.fromJason(Map<String,dynamic> jason){
    status = jason['status'];
    message = jason['message'];
    data = jason['data'] !=null ? UserData.fromJason(jason['data']):null;
  }
}

class UserData{
   int? id;
   String? name;
   String? email;
   String? phone;
   String? image;
   int? points;
   int? credit;
   String? token;

  UserData.fromJason(Map <String , dynamic> jason){
    id =jason['id'];
    name =jason['name'];
    email =jason['email'];
    phone =jason['phone'];
    image =jason['image'];
    points =jason['points'];
    credit =jason['credit'];
    token =jason['token'];
  }

}