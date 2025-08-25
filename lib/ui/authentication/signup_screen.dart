// ignore_for_file: unused_field

import 'dart:io';

import 'package:chat_app/ui/authentication/login_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/widgets/helper/input_field.dart';
import 'package:chat_app/widgets/helper/input_image.dart';
import 'package:chat_app/widgets/helper/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  var _nameText = '';
  var _emailText = '';
  var _passwordText = '';
  File? _selectedImage;
  bool _isUploading = false;

   void _onSumbit() async {
     final isValid =_formKey.currentState!.validate();
     if(!isValid) {
       return;
     }
     if(_selectedImage == null){
      Utils.snackBar('Please enter image', context);
      return;
     }
     _formKey.currentState!.save();

     try{
      setState(() {
        _isUploading = true;
      });
       final userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailText, 
      password: _passwordText);

      final userId = userCredential.user!.uid;

      // final ref = FirebaseStorage.instance
      // .ref().
      // child('user_image').
      // child('$userId.jpg');

      // await ref.putFile(_selectedImage!);
      // final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userId).set({

        'userName': _nameText,
        'email': _emailText,
        // 'image_url': imageUrl,
        'created_at': Timestamp.now()
      });

      Utils.snackBar('Successfully Signup', context);
      
      await FirebaseAuth.instance.signOut(); 

     Navigator.pushReplacement(
      context,
       MaterialPageRoute(builder: (context) => const LoginScreen()),
     );
      _formKey.currentState!.reset();


     } on FirebaseAuthException catch (e){

      if(e.code == 'email-already-in-use'){
        Utils.snackBar(e.message ?? 'email-already-in-use', context);
      }
       if(e.code == 'invalid-email'){
       
        Utils.snackBar(e.message ?? 'invalid email', context);
      }
      if(e.code == 'network-request-failed'){
       
        Utils.snackBar(e.message ?? 'network-request-failed', context);
      }
       setState(() {
        _isUploading = false;
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
           
            InputImage(onPickedImage: (pickedImage) {
              _selectedImage = pickedImage;
            },),
            const SizedBox(height: 15),
            InputField(
              prefixIcon: Icons.person_outline,
              hintText: "Full Name",
               validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'please enter name';
                    }      
                    return null; 
                  },
                   onSaved: (value){
                    _nameText = value!;
                  },
            ),
            const SizedBox(height: 15),

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

            RoundedButton(
              isUploading: _isUploading,
              lable: 'Sign Up',
              onTap: _onSumbit,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Login"),
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