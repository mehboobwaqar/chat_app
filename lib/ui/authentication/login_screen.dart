// ignore_for_file: unused_field

import 'package:chat_app/ui/authentication/signup_screen.dart';
import 'package:chat_app/ui/chat/chat_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/widgets/helper/input_field.dart';
import 'package:chat_app/widgets/helper/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _emailText = '';
  var _passwordText = '';
  bool _isLogin = false;

   void _onSumbit() async {
     final isValid =_formKey.currentState!.validate();
     if(!isValid){
     return;
     }
      _formKey.currentState!.save();
      try{
        setState(() {
          _isLogin = true;
        });

        await _auth.signInWithEmailAndPassword(email: _emailText, password: _passwordText);
          
         

          Utils.snackBar('Login successfully', context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatScreen()));

      } on FirebaseAuthException catch (e) {
  if (e.code == 'invalid-email') {
    Utils.snackBar(e.message ?? 'Invalid email', context);
  } else if (e.code == 'invalid-credential' || e.code == 'invalid-login-credentials') {
    Utils.snackBar(e.message ?? 'Invalid login credentials', context);
  } else if (e.code == 'user-not-found') {
    Utils.snackBar(e.message ?? 'User not found', context);
  } else if (e.code == 'wrong-password') {
    Utils.snackBar(e.message ?? 'Wrong password', context,);
  } else if (e.code == 'network-request-failed') {
    Utils.snackBar(e.message ?? 'Network error, please try again', context,);
  } else {
    Utils.snackBar(e.message ?? 'Authentication error', context,);
  }
  setState(() {
          _isLogin = false;
        });
}
      
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/chat.png',
                  height: 120,
                ),
                const SizedBox(height: 30),
            
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to continue chatting",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                InputField(
                  prefixIcon: Icons.email_outlined,
                  hintText: "Email",
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter email';
                    }
                    if(!value.contains('@')){
                      return 'please enter valid email';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _emailText = value!;
                  },
                  ),
              
                const SizedBox(height: 15),
            
                 InputField(
                  prefixIcon: Icons.lock_outline,
                  hintText: "Password",
                  obscureText: true,
                   validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter password';
                    }
                    if(value.length < 6){
                      return 'please enter 6 digit password';
                    }
                    return null; 
                  },
                   onSaved: (value){
                    _passwordText = value!;
                  },
                  ),
            
                const SizedBox(height: 20),
                RoundedButton(lable: 'Login', onTap: _onSumbit, isUploading: _isLogin),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignupScreen()));
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
