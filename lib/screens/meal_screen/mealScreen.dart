import 'dart:convert';

import 'package:appdid_taskk/screens/meal_details_screen/meal_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealsScreen extends StatelessWidget {
  final List<dynamic> meals;

  MealsScreen({required this.meals});

  Future<dynamic> _fetchMealDetails(String mealId) async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['meals'][0];
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0, 
          mainAxisSpacing: 8.0, 
          childAspectRatio: 1.0, 
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          var meal = meals[index];
          return GestureDetector(
            onTap: () {
              _fetchMealDetails(meal['idMeal']).then((mealDetails) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealDetailsScreen(mealDetails: mealDetails),
                  ),
                );
              }).catchError((error) {
                
                print('Error fetching meal details: $error');
              });
            },
            child: Card(
              elevation: 2.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    meal['strMealThumb'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    meal['strMeal'],
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
