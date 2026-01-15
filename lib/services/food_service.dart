import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food.dart';

class FoodService {
  static const String baseUrl = 'https://mubereats.onrender.com/api';

  /// Restaurant-ийн хоолнууд татах
  static Future<List<Food>> fetchFoods(int restaurantId) async {
    final url = Uri.parse('$baseUrl/restaurant/$restaurantId/foods/');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final body = json.decode(res.body);

      final List foodsJson = body['foods'];
      return foodsJson.map((e) => Food.fromJson(e)).toList();
    } else {
      throw Exception('Food fetch failed');
    }
  }
}
