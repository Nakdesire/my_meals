import 'package:flutter/material.dart';
import 'package:my_meals/src/screens/categories_meals_screen.dart';
import 'package:my_meals/src/screens/meal_detail_screen.dart';
import 'package:my_meals/src/screens/settings_screen.dart';
import 'package:my_meals/src/screens/tabs_screen.dart';

import 'data/dummy_data.dart';
import 'models/meal.dart';
import 'models/settings.dart';
import 'utils/app_routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Settings settings = Settings();
  List<Meal> _availableMeals = dummyMeals;
  List<Meal> _favoriteMeals = [];
  void _filterMeals(Settings settings) {
    setState(() {
      this.settings = settings;
      _availableMeals = dummyMeals.where((meal) {
        final filterGluten = settings.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = settings.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = settings.isVegan && !meal.isVegan;
        final filterVegetarian = settings.isVegetarian && !meal.isVegetarian;

        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromRGBO(31, 171, 137, 1),
          secondary: const Color.fromRGBO(157, 243, 196, 1),
          tertiary: const Color.fromRGBO(98, 210, 162, 1),
        ),
        canvasColor: const Color.fromRGBO(215, 251, 232, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      routes: {
        AppRoutes.home: (context) => TabsScreen(_favoriteMeals),
        AppRoutes.categoriesMeals: (context) =>
            CategoriesMealsScreen(_availableMeals),
        AppRoutes.mealDetail: (context) =>
            MealDetailScreen(_toggleFavorite, _isFavorite),
        AppRoutes.settings: (context) => SettingsScreen(settings, _filterMeals),
      },
    );
  }
}
