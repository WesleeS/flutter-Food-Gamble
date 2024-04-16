import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'foodCard.dart';
import 'recipeCard.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'GetHand.dart';


List<String> hand = [];

void main() async {
  List<dynamic> handDynamic = await GetHand();
  hand = handDynamic.map((item) => item.toString()).toList();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getMeals()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getMeals(),
      child: MaterialApp(
        title: 'Food Roulette',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class getMeals extends ChangeNotifier {
  List<String> idMealList = []; // A cost of tech debt, by the time I realized I wanted
                            // to randomly make a hand of cards, I already had this method
                            // setup like this. So, instead of each card picking itself,
                            // it grabs one of the ID's from here.
  String recipeViewID = "52772";
  bool hasPressed = false;
  int progressValue = 0;

  Future<void> fetchMealData() async {
    idMealList.clear(); // clearing it before filling. This looked nicer than an iterable of i++
    while (idMealList.length < 8) {
      final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));
      if (response.statusCode == 200) {
        var meals = jsonDecode(response.body)['meals'];
          var idMeal = meals[0]['idMeal']; // saves to idMeal and then makes sure there's no dupes
          if (!idMealList.contains(idMeal)) {
            idMealList.add(idMeal);
          }
      } else {
        throw Exception('Failed to load meal');
      }
    }
    notifyListeners();
  }

  void getNext() async {
    await fetchMealData(); // had to do an await, the card wasn't updating proper otherwise.
    notifyListeners();
    hasPressed = true;
  }

  void getSaved() async {
    print("waow!");
    print(hand);
    idMealList = hand;
  
    notifyListeners();
    hasPressed = true;
  }

  void getRecipeID(id) async {
    recipeViewID = id;
    print(recipeViewID);
    notifyListeners();
  }

}




class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<getMeals>();
    var idList = appState.idMealList;
    var hasPressed = appState.hasPressed;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Meal Gamble!'),
            Text('Rules:'),
            Text('-Draw a hand of 8, discard 1'),
            Text('-See how many you can eat in 7 days'),
            if(hasPressed)
              Text('Click an image to see the recipe!'),
            if(!hasPressed)
              SizedBox(height: 10),
            if(!hasPressed)
              Text('Be patient, it loads slow from await calls'),
            
                  

            if(hasPressed)
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Column(children: [Consumer<getMeals>(
                  builder: (context, appState, _) {
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: idList.take(4).map((id) {
                            return BigCard(idMeal: id, getRecipeID: appState.getRecipeID);
                          }).toList(),
                        ),
                        Row(
                          children: idList.skip(4).map((id) {
                            return BigCard(idMeal: id, getRecipeID: appState.getRecipeID);
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ],),
              Column(children: [
                RecipeCard(idMeal : appState.recipeViewID)
                ]),
          ]),
            
              
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Draw Hand'),
            ),

            if(hasPressed)
              ElevatedButton(
                onPressed: () {
                  appState.getSaved();
                },
                child: Text("Load Weslee's Hand"),
              ),
              ]
            )
            

          ],
        ),
      ),
    );
  }
}

