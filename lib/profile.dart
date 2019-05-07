import 'package:flutter/material.dart';
import 'auth.dart';

class ProfilePage extends StatefulWidget{
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage>{

  void _signout() async{
    if(AuthService.user.isAnonymous){
      await AuthService.auth.signOut();
    }
    else if(AuthService.user.isEmailVerified){
      await AuthService.googleSignIn.signOut();
      await AuthService.googleSignIn.disconnect();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text('Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: (){
              _signout();
              print(AuthService.user.toString() + ' signed out successfully');
              Navigator.of(context).pushNamedAndRemoveUntil('/mallmain', (Route<dynamic> route) => false);
            },
          ),
        ]
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0 ,horizontal: 20.0),
        children: [
          Container(
            child: AuthService.user.isAnonymous ? Image.network(AuthService.defaultImgUrl) : Image.network(AuthService.user.photoUrl),
          ),
          Column(
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AuthService.user.uid,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  color: Colors.white,
                  height: 3.0
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AuthService.user.isAnonymous ? 'Anonymous' : AuthService.user.email,
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white,
                    )
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}