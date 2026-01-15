import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const RestaurantDemoApp());

class RestaurantDemoApp extends StatelessWidget {
  const RestaurantDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RestaurantPage(),
    );
  }
}

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  bool isLoading = true;
  int selectedCategoryIndex = 0;

  // ---------------- REST INFO ----------------
  final String restaurantName = 'MuBu Eats';
  final String bannerImg =
      'https://images.unsplash.com/photo-1600891964599-f61ba0e24092';
  final String profileImg =
      'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe';
  final double rating = 4.8;
  final String openTime = '10:00';
  final String closeTime = '23:00';

  List<Map<String, dynamic>> allFoods = [];

  final List<Map<String, dynamic>> categories = [
    {'name': 'Бүх хоол', 'items': []},
    {'name': 'Пицца', 'items': []},
    {'name': 'Багц', 'items': []},
    {'name': 'Уух зүйлс', 'items': []},
  ];

  @override
  void initState() {
    super.initState();
    fetchFoods();
  }

  // ---------------- API ----------------
  Future<void> fetchFoods() async {
    const int resID = 21;
    final url = Uri.parse(
        'https://mubereats.onrender.com/api/restaurant/$resID/foods/');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final List foods = data['foods'];

        final mapped = foods.map((f) {
          return {
            'title': f['foodName'],
            'subtitle': f['description'] ?? '',
            'price': '${f['price']}₮',
            'img': f['image_url'] ?? profileImg,
          };
        }).toList();

        setState(() {
          allFoods = List<Map<String, dynamic>>.from(mapped);
          categories[0]['items'] = allFoods;
          categories[1]['items'] = allFoods; // түр
          isLoading = false;
        });
      }
    } catch (_) {
      isLoading = false;
    }
  }

  List<Map<String, dynamic>> get items =>
      List<Map<String, dynamic>>.from(
          categories[selectedCategoryIndex]['items']);

  Widget _img(String url,
      {double? w, double? h, BoxFit fit = BoxFit.cover}) {
    return Image.network(url, width: w, height: h, fit: fit);
  }

  // ---------------- TOP BANNER (HEADER БИШ) ----------------
  Widget _topBanner() {
    return Stack(
      children: [
        _img(bannerImg, h: 200, w: double.infinity),
        Container(
          height: 200,
          color: Colors.black.withOpacity(0.35),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: NetworkImage(profileImg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurantName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.orange, size: 16),
                        Text(' $rating',
                            style:
                                const TextStyle(color: Colors.white)),
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule,
                            color: Colors.white, size: 16),
                        Text(' $openTime - $closeTime',
                            style:
                                const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- CATEGORIES ----------------
  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (_, i) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(categories[i]['name']),
              selected: selectedCategoryIndex == i,
              onSelected: (_) =>
                  setState(() => selectedCategoryIndex = i),
              selectedColor: Colors.orange,
              labelStyle: TextStyle(
                color: selectedCategoryIndex == i
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- POPUP ----------------
  void _showFoodDetails(Map item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(16))),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _img(item['img'],
                  h: 180, w: double.infinity),
            ),
            const SizedBox(height: 12),
            Text(item['title'],
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(item['subtitle'],
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['price'],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Сагсанд нэмэх'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(Map item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => _showFoodDetails(item),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _img(item['img'], w: 60, h: 60),
        ),
        title: Text(item['title']),
        subtitle: Text(item['subtitle']),
        trailing: Text(item['price']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _topBanner(),
            _categories(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: items.map(_menuItem).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
