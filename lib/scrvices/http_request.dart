import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:passwise_security/sharedPreferences/user_preferences.dart';
import 'package:passwise_security/views/visitor_allowed.dart';

class HttpRequest {

  String baseUrl = "https://api.passwise.app/api/";

  Future<List> getAllPasses(String token) async {
    token = token;
    http.Response response = await http.get(
      Uri.parse(baseUrl + "passes"),
      headers: <String, String>{
        "Content-Type": "application/json",
        // "Cookie": "auth_token=" + UserPreferences.getUserToken()!
        "Authorization": "Bearer " + UserPreferences.getUserToken()!
      },
    );
    if (response.statusCode == 200) {
      //print("Rsponse received");
      //print(jsonDecode(response.body));
      return(jsonDecode(response.body));
    } else {
      // print("Rsponse Not received");
      // print(response.statusCode);
      return [];
    }
  }

  Future<String> singnIn(String username, String password) async {
    print("Email = "+username);
    print("Password = "+password);

    Map<String, String> loginRequestBody = {
      'email': username,
      'password': password
    };

    var body = json.encode(loginRequestBody);

    final response = await http.post(
      Uri.parse(baseUrl + "login"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if(response.statusCode==200){
      print("response.statusCode = "+response.statusCode.toString());
      print(response.body);


      if(jsonDecode(response.body)["user"]["user_role"]=="Security"){
        String x = jsonDecode(response.body)["expiresIn"];
        // List<String> c = x.split(""); // ['a', 'a', 'a', 'b', 'c', 'd']
        // c.removeLast(); // ['a', 'a', 'a', 'b', 'c']
        // x = c.join();

        DateTime expiryTime = DateTime.now().add(Duration(seconds: int.parse(x)));

        UserPreferences.setUserToken(jsonDecode(response.body)["token"]);
        UserPreferences.setExpiryTime(expiryTime.toString());
        UserPreferences.setCompanyName(jsonDecode(response.body)["user"]['office']);

        // print("DateTime.now().second"+DateTime.now().toString());
        // print("expiryTime.second"+expiryTime.toString());



        //print("ExpiryTime = "+jsonDecode(response.body)["expiresIn"]);
        //token = jsonDecode(response.body)["token"];
        return response.body;
      }else{
        print("FIRST ELSE PART");
        return "null";
      }
    }
    else
      {
        print("SECOND ELSE PART");
        print(response.statusCode.toString());
        return "null";
      }

  }

  Future<String> scanQR(String qrString)async{

    var headers = {
      'Content-Type': 'application/json',
      // "Cookie": "auth_token=" + UserPreferences.getUserToken()!
      "Authorization": "Bearer " + UserPreferences.getUserToken()!
    };

    var request = http.Request('POST', Uri.parse(baseUrl+'passCheck'));
    request.body = json.encode({
      "key": qrString
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print("if part of Send QR");
      // print(await response.stream.bytesToString());

      return response.stream.bytesToString();
    }
    else {
    //   print("Else part of Send QR");
    // print(response.reasonPhrase);
    return "Not allowed";
    }

  }


  // Future<String?> addVisitor(AddVisitorModel addVisitorModel)async{
  //
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     // 'Cookie': 'auth_token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNmRlMDYzNGJiZjRlOTNiOTg2OWU1MyIsImlhdCI6MTY3MTYwMjYyNiwiZXhwIjoxNjcxNjQ1ODI2fQ.YxowVkehKMy0CzuSUnDCCZZ7t8CFPppOkSD9bC_Aydw'
  //     'Cookie': 'auth_token='+UserPreferences.getUserToken()!
  //   };
  //   var request = http.Request('POST', Uri.parse('https://api.passwise.app/passGen'));
  //
  //   request.body = json.encode(addVisitorModel.toJson());
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   // print("Response status code = "+response.statusCode.toString());
  //
  //   if (response.statusCode == 200) {
  //     // print(await response.stream.bytesToString());
  //     return "allowed";
  //   }
  //   else {
  //     // print(response.reasonPhrase);
  //     return response.reasonPhrase;
  //   }
  // }
  //
  // Future<String> uploadImage(String file)async{
  //
  //   var headers = {
  //     'Cookie': 'auth_token='+UserPreferences.getUserToken()!
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('https://api.passwise.app/imageUpload'));
  //   request.files.add(await http.MultipartFile.fromPath('image', file));
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     // print("if part of Image");
  //   // print(await response.stream.bytesToString());
  //   return await response.stream.bytesToString();
  //   }
  //   else {
  //     // print("else part of Image");
  //   // print(response.reasonPhrase);
  //   return "null";
  //   }
  // }

}
