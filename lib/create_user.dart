import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'model/accounts.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  var _fkey = GlobalKey<FormState>();
  var _sKey = GlobalKey<ScaffoldState>();
  String _mail;
  String _password;
  String _name;
  String _surname;
  String _phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ekranı"),
        centerTitle: true,
      ),
      key: _sKey,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 110, right: 110),
          child: Center(
            child: Form(
                key: _fkey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                            height: 150,
                            width: 300,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/800px-International_Pok%C3%A9mon_logo.svg.png"),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(height: 20,),
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
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "İsim Giriniz",
                          hintText: "İsim",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (s) {
                          if (s.length < 3) {
                            return "3 Karakterden Kısa Olamaz";
                          } else
                            return null;
                        },
                        onSaved: (s) {
                          setState(() {
                            _name = s;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Soyisim Giriniz",
                          hintText: "Soyisim",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (s) {
                          if (s.length < 3) {
                            return "3 Karakterden Kısa Olamaz";
                          } else
                            return null;
                        },
                        onSaved: (s) {
                          setState(() {
                            _surname = s;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Telefon Giriniz",
                          hintText: "Telefon",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (s) {
                          if (s.length < 3) {
                            return "13 Karakterden Kısa Olamaz";
                          } else
                            return null;
                        },
                        onSaved: (s) {
                          setState(() {
                            _phone = s;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
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
                                color: Colors.orange,
                                child: Text("Kayıt Ol",
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                                onPressed: () {
                                  if (_fkey.currentState.validate()) {
                                    _fkey.currentState.save();
                                    _createUser(Accounts(_mail, _password,
                                        _name, _surname, _phone));
                                  } else
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

  void _createUser(Accounts accounts) async {
    var result = await _auth.createUserWithEmailAndPassword(
        email: accounts.mail, password: accounts.password);
    var created = result.user;
    if (created != null) {
      created.sendEmailVerification().then((value) {
        _sKey.currentState.showSnackBar(SnackBar(
          content: Text("Onay Maili Gönderildi, Lütfen Onaylayın!"),
          duration: Duration(seconds: 4),
        ));
        Navigator.pop(context);
      }).catchError((e) {
        _sKey.currentState.showSnackBar(SnackBar(
          content: Text("Mail Hatalı"),
          duration: Duration(seconds: 4),
        ));
      });
      _firestore
          .doc("/accounts/${accounts.mail}")
          .set(accounts.toMap())
          .catchError((e) => debugPrint("Veri Tabanına Kaydedilemedi"));
    } else {
      _sKey.currentState.showSnackBar(SnackBar(
        content: Text("Mail Kullanımda"),
        duration: Duration(seconds: 4),
      ));
    }
  }
}
