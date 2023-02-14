import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passwise_security/constants/custom_colors.dart';
import 'package:passwise_security/scrvices/http_request.dart';
import 'package:passwise_security/views/visitor_list.dart';
import 'package:passwise_security/widgets/custom_bottom_sheet.dart';
import 'package:passwise_security/widgets/custom_button.dart';
import 'package:passwise_security/widgets/custom_text_form_field.dart';
import 'package:passwise_security/widgets/our_scaffold.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailControllar = TextEditingController();
  TextEditingController passwordControllar = TextEditingController();
  HttpRequest loginRequestObject = HttpRequest();
  bool isLaoding = false;
  bool hidePassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return OurScaffoldTemplate(
        showFAB: false,
      appBarWidget: Column(
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("PASS "),
                Text(
                  "WISE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Flexible(
            child:  Image.asset('assets/logo/logo.png'),
          ),
        ],
      ),
        bodyWidget:  !isLaoding? SingleChildScrollView(
    child: Form(
    key: formKey,
      child: Container(
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: Column(
          children: [
            Text(
              "Sign in",
              style: TextStyle(
                  color: CustomColors().customBlueColor,
                  fontSize: 23,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFieldCustomerBuilt(
              textInputType: TextInputType.emailAddress,
              hintTxt: "Email",
              //icoon: Icons.email,
              isEmail: true,
              icoon: Icons.email,
              controller: emailControllar,
            ),
            TextFormFieldCustomerBuilt(
              eyeIcon: InkWell(
                  onTap: (){
                    _togglePasswordView();
                  },
                  child: Icon(hidePassword
                      ? Icons.visibility
                      : Icons.visibility_off,color: CustomColors().customBlueColor,)),
              obscText: hidePassword,
              showEyeIcon: true,
              hintTxt: "Password",
              icoon: Icons.key,
              controller: passwordControllar,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Forgot password?"),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomButtonWidget(
                    btntext: 'Sign in',
                    btnonPressed: signInfunction
                )
              ],
            ),
          ],
        ),
      ),
    ),
    ):
    Center(child: CircularProgressIndicator(color: CustomColors().customBlueColor,))
    );
  }

  void _togglePasswordView() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void signInfunction() async {
    final isValid = formKey.currentState?.validate();
    if(isValid!){
      setState(() {
        isLaoding = true;
      });
      String data = await loginRequestObject.singnIn(emailControllar.text, passwordControllar.text);
      // print(jsonDecode(data));
      if(data!='null'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>VisitorList()));
      }
      else{
        setState(() {
          isLaoding = false;
        });
        //print("Toast");
        showToast();
      }
    }

  }

  void showToast() {
    Fluttertoast.showToast(
        msg: "Invalid username or password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
