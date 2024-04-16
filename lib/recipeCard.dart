


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.idMeal,
  }) : super(key: key);

  final String idMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headline6!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      width: 400,
      height: 540,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder<Meal>(
            future: fetchMealData(idMeal),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    Text(
                        snapshot.data!.strMeal,
                        style: style,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 10),
                    Text(
                        snapshot.data!.strInstructions,
                        style: style,
                      ),
                    
                  ],
                );
              }
            },
          ),
          ),
        ),
      ),
    );
  }

  Future<Meal> fetchMealData(String idMeal) async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'));
    if (response.statusCode == 200) {
      var meals = jsonDecode(response.body)['meals'];
      if (meals != null && meals.isNotEmpty) {
        return Meal.fromJson(meals[0]);
      } else {
        throw Exception('Meal not found');
      }
    } else {
      throw Exception('Failed to load meal');
    }
  }
}


class Meal {
  final String strMeal;
  final String strInstructions;

  Meal({required this.strMeal, required this.strInstructions});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strMeal: json['strMeal'],
      strInstructions: json['strInstructions'],
    );
  }
}
