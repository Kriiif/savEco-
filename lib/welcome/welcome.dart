import 'package:flutter/material.dart';
import 'package:saveco_project/login/login.dart';
import 'package:saveco_project/register/register.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: Container(

          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ), // Spacing between text and image
                  Image.asset(
                    'assets/images/savecoo.png', // Replace with your image path
                    height: 300, // Adjust the height as needed
                  ),
                ],
              ),

              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      // side: BorderSide(
                      //   color: Colors.blue[400]
                      // ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blue[400],
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                    },
                    color: Colors.blue[400],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white
                      ),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
        )),
    );
  }
}