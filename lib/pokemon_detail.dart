import 'package:flutter/material.dart';
import 'package:pokedex/model/pokedex.dart';

class PokemonDetail extends StatelessWidget {
  Pokemon pokemon;
  PokemonDetail({this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Text(
          pokemon.name,
          textAlign: TextAlign.center,
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return dikeyBody(context);
        } else {
          return yatayBody(context);
        }
      }),
    );
  }

  Widget dikeyBody(BuildContext context) {
    return Hero(
      tag: pokemon.img,
      child: Stack(
        children: <Widget>[
          Positioned(
              height: MediaQuery.of(context).size.height * (7 / 10),
              width: MediaQuery.of(context).size.width - 20,
              left: 10,
              top: MediaQuery.of(context).size.height * 0.1,
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 100),
                    Text(
                      pokemon.name,
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Height:" + pokemon.height,
                    ),
                    Text(
                      "Weight:" + pokemon.weight,
                    ),
                    Text(
                      "Types",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pokemon.type
                          .map((tip) => Chip(
                                label: Text(
                                  tip,
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.deepOrange,
                              ))
                          .toList(),
                    ),
                    Text(
                      "Prev Evolution",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pokemon.prevEvolution != null
                            ? pokemon.prevEvolution
                                .map((preevolution) => Chip(
                                      label: Text(
                                        preevolution.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepOrange,
                                    ))
                                .toList()
                            : [Text("No Have Prev Evolution")]),
                    Text(
                      "Next Evolution",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pokemon.nextEvolution != null
                            ? pokemon.nextEvolution
                                .map((evolution) => Chip(
                                      label: Text(
                                        evolution.name,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepOrange,
                                    ))
                                .toList()
                            : [Text("Last Evolution")]),
                    Text(
                      "Weaknesses",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pokemon.weaknesses != null
                            ? pokemon.weaknesses
                                .map((weakness) => Chip(
                                      label: Text(
                                        weakness,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.deepOrange,
                                    ))
                                .toList()
                            : [Text("Zayıflığı Yok")]),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(pokemon.img), fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget yatayBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 10,
          right: 10,
          child: Container(
            height: MediaQuery.of(context).size.height * (4 / 5),
            width: MediaQuery.of(context).size.width - 20,
            margin: EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Hero(
                        tag: pokemon.img,
                        child: Container(
                          height: 300,
                          width: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(pokemon.img),
                                fit: BoxFit.fill),
                          ),
                        ))),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        pokemon.name,
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Height:" + pokemon.height,
                      ),
                      Text(
                        "Weight:" + pokemon.weight,
                      ),
                      Text(
                        "Types",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: pokemon.type
                            .map((tip) => Chip(
                                  label: Text(
                                    tip,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.deepOrange,
                                ))
                            .toList(),
                      ),
                      Text(
                        "Prev Evolution",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: pokemon.prevEvolution != null
                              ? pokemon.prevEvolution
                                  .map((preevolution) => Chip(
                                        label: Text(
                                          preevolution.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.deepOrange,
                                      ))
                                  .toList()
                              : [Text("No Have Prev Evolution")]),
                      Text(
                        "Next Evolution",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: pokemon.nextEvolution != null
                              ? pokemon.nextEvolution
                                  .map((evolution) => Chip(
                                        label: Text(
                                          evolution.name,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.deepOrange,
                                      ))
                                  .toList()
                              : [Text("Last Evolution")]),
                      Text(
                        "Weaknesses",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: pokemon.weaknesses != null
                              ? pokemon.weaknesses
                                  .map((weakness) => Chip(
                                        label: Text(
                                          weakness,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.deepOrange,
                                      ))
                                  .toList()
                              : [Text("Zayıflığı Yok")]),
                    ],
                  ),
                  flex: 6,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
