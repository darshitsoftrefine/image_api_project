import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../models/pizza_model.dart';

class PizzaController extends GetxController {

  @override
  void onInit(){
    getRecipes();
    super.onInit();
  }

  List recipe = <Recipes>[];

  Future getRecipes() async{
    const String url = "https://forkify-api.herokuapp.com/api/search?q=pizza#";
    var response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      try {
        final result = jsonDecode(response.body);
        for (var i = 0; i < result['recipes'].length; i++) {
          final entry = result['recipes'][i];
          recipe.add(Recipes.fromJson(entry));
        }
        update();
        return recipe;
      } catch(e){
        debugPrint("Error call $e");
        throw Exception(e.toString());
      }
    }
  }

}