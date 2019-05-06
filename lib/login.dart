import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _success = false;
  String _uid;

  Future<FirebaseUser> _handleGoogleSignIn() async{
    final GoogleSignInAccount googleUser = await AuthService.googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    if(googleUser == null){
      print('Google login failed!');
      return null;
    }

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await AuthService.auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    print(user.email);
    print(user.displayName);
    print(user.isAnonymous);
    print(user.getIdToken());

    final FirebaseUser currentUser = await AuthService.auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState((){
      if(user != null){
        _success = true;
        _uid = user.uid;
        AuthService.user = user;
        /* Firestore.instance.collection('accounts').document('google').setData({
          'email' : user.email,
          'photourl': user.photoUrl,
          'displayName' : user.displayName,
        }); */
        Navigator.pop(context);
      }
      else{
        _success = false;
      }
    });
    print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> _handleAnonymous() async{
    final FirebaseUser user = await AuthService.auth.signInAnonymously();
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if(Platform.isIOS){
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    }
    else if(Platform.isAndroid){
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
    }

    final FirebaseUser currentUser = await AuthService.auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState((){
      if(user != null){
        _success = true;
        _uid = user.uid;
        AuthService.user = user;
        print('Successfully signed in as a guest [uid]: ' + _uid);
        Navigator.pop(context);
        /* Firestore.instance.collection('accounts').document('anonymous').setData({
            'uid' : user.email,
            'isAnonymous': user.isAnonymous,
            'displayName' : user.displayName,
        }); */
      }
      else{
        _success = false;
      }
    });
    return user;
  }

  @override
  Widget build(BuildContext context) {
    String _googleLogoUrl = 'https://firebasestorage.googleapis.com/v0/b/mallapp-project.appspot.com/o/google-logo.png?alt=media&token=07f4a442-e727-4168-909a-0c9dc4786ace';
    String _anonymousImgUrl = 'https://firebasestorage.googleapis.com/v0/b/mallapp-project.appspot.com/o/question-mark.png?alt=media&token=66e9497b-d8cf-475a-9d7d-dc21c0a1c729';
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/diamond.png',
                  color: kShrineBrown900),
                SizedBox(height: 16.0),
                Text('JMall'),
              ],
            ),
            SizedBox(height: 120.0),
            // [Name]
            ButtonTheme(
              minWidth: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.red[200],
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: SizedBox(
                          width: 30.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Image.network(_googleLogoUrl),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Row(
                        children:[
                          Text('Google',
                            style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                onPressed: (){
                  _handleGoogleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)); //Pop up google sign in
                },
              ),
            ),
            SizedBox(height: 12.0),
            ButtonTheme(
              minWidth: 50.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Colors.grey,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        child: SizedBox(
                          width: 30.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Image.network(_anonymousImgUrl),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      Row(
                        children:[
                          Text('Guest',
                            style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                onPressed: (){
                  _handleAnonymous().then((FirebaseUser user) => print(user)).catchError((e) => print(e));
                },
              ),
            ),
            
            ],
          ),
        ),
      );
    }
}

class AccentColorOverride extends StatelessWidget{
  const AccentColorOverride({Key key, this.color, this.child}) : super(key : key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context){
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        accentColor: color,
        brightness: Brightness.dark,
      )
    );
  }
}