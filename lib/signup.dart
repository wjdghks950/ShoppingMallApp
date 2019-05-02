import 'package:flutter/material.dart';

class SignUp extends StatefulWidget{
  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUp>{
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _emailController = TextEditingController();
  List<bool> _validate = [];

  void initValidate(){
    var i = 0;
    for (i = 0; i < 4; i++){
      _validate.add(false);
    }
  }

  bool checkValidate(){
    var i = 0;
    for (i = 0; i < 4 ; i++){
      print("${i}th:" + _validate[i].toString());
      if(_validate[i]){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context){
    initValidate();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration:InputDecoration(
                    filled: true,
                    labelText:'Username',
                    errorText: _validate[0] ? 'Please enter Username' : null,
                  ),
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _passwordController,
                  decoration:InputDecoration(
                    filled: true,
                    labelText:'Password',
                    errorText:  _validate[1] ? 'Please enter Password': null,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _confirmController,
                  decoration:InputDecoration(
                    filled: true,
                    labelText:'Confirm Password',
                    errorText:  _validate[2] ? 'Please enter Confirm Password' : null,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 12.0),
                TextField(
                  controller: _emailController,
                  decoration:InputDecoration(
                    filled: true,
                    labelText:'Email Address',
                    errorText:  _validate[3] ? 'Please enter email address' : null,
                  ),
                ),
                SizedBox(height: 12.0),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text('SIGN UP'),
                      onPressed: (){
                         setState((){
                          _usernameController.text.isEmpty ? _validate[0] = true : _validate[0] = false;
                          _passwordController.text.isEmpty ? _validate[1] = true : _validate[1] = false;
                          _confirmController.text.isEmpty ? _validate[2] = true : _validate[2] = false;
                          _emailController.text.isEmpty ? _validate[3] = true : _validate[3] = false; 
                        });
                        if(checkValidate()){
                          Navigator.pop(context);
                        }
                      }
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}