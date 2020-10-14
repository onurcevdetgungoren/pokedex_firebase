import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokedex/create_user.dart';
import 'package:pokedex/pokemon_list.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'model/accounts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  var _fkey = GlobalKey<FormState>();
  var _sKey = GlobalKey<ScaffoldState>();
  String _mail;
  String _password;
  AnimationController controller;
  SequenceAnimation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this);
    animation = SequenceAnimationBuilder()
        .addAnimatable(
            animatable: Tween<double>(begin: 30, end: 150),
            from: Duration(seconds: 0),
            to: Duration(seconds: 4),
            tag: "height")
        .addAnimatable(
            animatable: Tween<double>(begin: 60, end: 300),
            from: Duration(seconds: 0),
            to: Duration(seconds: 4),
            tag: "width")
        .animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sKey,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only( left: 110, right: 110),
          child: Center(
            child: Form(
                key: _fkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: controller,
                        builder: (context, Widget child) {
                          return Container(
                            height: animation["height"].value,
                            width: animation["width"].value,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/800px-International_Pok%C3%A9mon_logo.svg.png"),
                                  fit: BoxFit.fill),
                            ),
                          );
                        },
                      ),
                      InkWell(
                        onTap: () {
                          _signWithGoogle(Accounts.forAuth(_mail, _password));
                        },
                        child: Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://i.stack.imgur.com/VHSZf.png"),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Mail Adresini Giriniz",
                          hintText: "e-Mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (s) {
                          if (s.length < 15) {
                            return "15 Karakterden Kısa Olamaz";
                          } else
                            return null;
                        },
                        onSaved: (s) {
                          setState(() {
                            _mail = s;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Şifrenizi Giriniz",
                          hintText: "Şifre",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (s) {
                          if (s.length < 8) {
                            return "8 Karakterden Kısa Olamaz";
                          } else
                            return null;
                        },
                        onSaved: (s) {
                          setState(() {
                            _password = s;
                          });
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 150,
                            height: 50,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)),
                                color: Colors.pinkAccent.shade400,
                                child: Text("Kayıt Ol",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateUser()));
                                }),
                          ),
                          ButtonTheme(
                            minWidth: 150,
                            height: 50,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red)),
                                color: Colors.orange,
                                child: Text("Giriş Yap",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  if (_fkey.currentState.validate()) {
                                    _fkey.currentState.save();
                                    _logIn(Accounts.forAuth(
                                      _mail,
                                      _password,
                                    ));
                                  }
                                  return null;
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void _logIn(Accounts accounts) async {
    var result = await _auth
        .signInWithEmailAndPassword(
            email: accounts.mail, password: accounts.password)
        .catchError((e) {
      _sKey.currentState.showSnackBar(SnackBar(
          content: Text("E-mail Veya Şifre Hatalı"),
          duration: Duration(seconds: 4)));
    });
    var enteredUser = result.user;
    if (enteredUser.emailVerified) {
      _sKey.currentState.showSnackBar(SnackBar(
        content: Text("Giriş Başarı İle Sağlandı"),
        duration: Duration(seconds: 4),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PokemonList()));
    } else {
      _sKey.currentState.showSnackBar(SnackBar(
          content: Text("Mailinize Gelen Maili Onaylayın"),
          duration: Duration(seconds: 4)));
      _auth.signOut();
    }
  }

  void _signWithGoogle(Accounts accounts) {
    _googleAuth.signIn().then((result) {
      result.authentication.then((googleKeys) {
        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleKeys.idToken, accessToken: googleKeys.accessToken);
        _auth.signInWithCredential(credential).then((user) {
          var entered = user.user;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PokemonList()));
        }).catchError((e) {
          _sKey.currentState.showSnackBar(SnackBar(
              content: Text("Doğrulama Hatası Oluştu"),
              duration: Duration(seconds: 4)));
        });
      }).catchError((e) {
        _sKey.currentState.showSnackBar(SnackBar(
            content: Text("Hesap Onayı Hatası"),
            duration: Duration(seconds: 4)));
      });
    }).catchError((e) {
      _sKey.currentState.showSnackBar(SnackBar(
          content: Text("Giriş Hatası"), duration: Duration(seconds: 4)));
    });
  }
}
