import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.idMeal,
    required this.getRecipeID,
  }) : super(key: key);

  final String idMeal;
  final Function(String) getRecipeID;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headline6!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: 200,
        maxHeight: 270,
      ),
      child: Card(
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                    GestureDetector(
                      onTap: () {
                        getRecipeID(idMeal);
                      },
                    child: Image.network(snapshot.data!.strMealThumb)),
                    SizedBox(height: 5),
                    Text(
                        snapshot.data!.strMeal,
                        style: style,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                );
              }
            },
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
  final String strMealThumb;

  Meal({required this.strMeal, required this.strMealThumb});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      strMeal: json['strMeal'],
      strMealThumb: json['strMealThumb'],
    );
  }
}
