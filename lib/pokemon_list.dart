import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/pokemon_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/signing_page.dart';

import 'model/pokedex.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  String url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  Pokedex pokedex;
  //Json içerisinde tüm pokemonları tutan ana gövde. Yani modelde ana class
  Future<Pokedex> _pokemonlariGetir;
  //Yukardaki değişkenimizi oluşturduk ve pokemonlariGetir() methodumuzu initState içerisinde bu değişkene atıp,
  //FutureBuilder da bu değişkeni çağıracağız. Çünkü direk methodumuzu çağırdığımızda, her defasında internetten çekiyor
  //Bu da perdformansı düşürecek bir etken.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Pokedex> pokemonlariGetir() async {
    var response = await http.get(url);
    var decodedJson = json.decode(response.body);
    pokedex = Pokedex.fromJson(decodedJson);
    return pokedex;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pokemonlariGetir = pokemonlariGetir();
    //Değişkenimize attık
    //FutureBuilder da bu değişkeni çağıracağız. Çünkü direk methodumuzu çağırdığımızda, her defasında internetten çekiyor
    //Bu da perdformansı düşürecek bir etken.
  }

  //YUKARIDA YAZDIĞIMIZ JSON METHODU AŞAĞIDAKİ GİBİDE YAZILABİLİRDİ.
  /*Future<Pokedex> pokemonGetir() async{
    var response = await http.get(url);
    if(response.statucode == 200){
    return Pokedex.fromJson(json.decode(response.body));
    } else {
      return throw Exception("Bağlanamadık + ${response.statusCode}");
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                if (_auth.currentUser != null) {
                  _auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              }),
        ],
      ),
      body: OrientationBuilder(
        //Yan yatırdığımızda daha düzgün görüntü olması için komple FutureBuilderdan itibaren, orientation BUlder ile sardık.
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            //orientation yani cihaz dik durumda iken;
            //DİK İKEN
            return FutureBuilder(
                future: _pokemonlariGetir,
                builder: (BuildContext context, AsyncSnapshot<Pokedex> sonuc) {
                  if (sonuc.hasData) {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PokemonDetail(
                                          pokemon: sonuc.data.pokemon[index])));
                            },
                            child: Hero(
                                tag: sonuc.data.pokemon[index].img,
                                child: Card(
                                  elevation: 6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          width: 400,
                                          height: 300,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: "assets/loading.gif",
                                            image:
                                                sonuc.data.pokemon[index].img,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          sonuc.data.pokemon[index].name,
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else {
            //YATAY İKEN
            //cihaz dik durumda değil iken yani YATAY iken
            return FutureBuilder(
                future: _pokemonlariGetir,
                builder: (BuildContext context, AsyncSnapshot<Pokedex> sonuc) {
                  if (sonuc.hasData) {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          //Burada Sliverın boyut göre kaç adet sığarsa okadar sığdır özelliğini kullandık, diğerlerinde countu kullanıpğ kaç adet
                          //Sığacaksa GridCount: 2 diyerek kendimiz belirtiyorduk.
                          maxCrossAxisExtent: 500,
                          //Sığdırılması gereken Gridlerin boyutu
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PokemonDetail(
                                          pokemon: sonuc.data.pokemon[index])));
                            },
                            child: Hero(
                                tag: sonuc.data.pokemon[index].img,
                                child: Card(
                                  elevation: 6,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 350,
                                        height: 250,
                                        child: FadeInImage.assetNetwork(
                                          placeholder: "assets/loading.gif",
                                          image: sonuc.data.pokemon[index].img,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      Text(
                                        sonuc.data.pokemon[index].name,
                                        style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
