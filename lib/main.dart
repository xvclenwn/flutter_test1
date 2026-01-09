import 'package:flutter/material.dart';

void main() => runApp(const RestaurantDemoApp());

class RestaurantDemoApp extends StatelessWidget {
  const RestaurantDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant UI Demo',
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
  final TextEditingController _bagNameCtrl = TextEditingController();

  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Пицца',
      'items': [
        {
          'title': 'Хос Пицца - Супер',
          'subtitle': 'Хавай / Маханд дурлагсад',
          'price': '62,000₮',
          'img': 'assets/images/pizza1.jpg'
        },
        {
          'title': 'Пеперони Пицца',
          'subtitle': 'Пеперони',
          'price': '32,000₮',
          'img': 'assets/images/pizza2.jpg'
        },
      ],
    },
    {
      'name': 'Багц',
      'items': [],
    },
    {
      'name': 'Уух зүйлс',
      'items': [
        {
          'title': 'Кока-Кола 330мл',
          'subtitle': 'Хүйтэн ундаа',
          'price': '3,500₮',
          'img': 'assets/images/coke.png'
        },
      ],
    },
  ];

  int selectedCategoryIndex = 0;

  List<Map<String, dynamic>> get filteredItems =>
      List<Map<String, dynamic>>.from(categories[selectedCategoryIndex]['items']);

  List<Map<String, dynamic>> get pizzas =>
      List<Map<String, dynamic>>.from(categories.firstWhere((c) => c['name'] == 'Пицца')['items']);

  List<Map<String, dynamic>> get drinks =>
      List<Map<String, dynamic>>.from(categories.firstWhere((c) => c['name'] == 'Уух зүйлс')['items']);

  int get bagIndex => categories.indexWhere((c) => c['name'] == 'Багц');

  // ---------------- IMAGE ----------------
  Widget _imageFor(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (path.startsWith('http')) {
      return Image.network(path, width: width, height: height, fit: fit);
    } else {
      return Image.asset(path, width: width, height: height, fit: fit);
    }
  }

  // ---------------- ITEM DETAILS ----------------
  void _showItemDetails(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _imageFor(item['img'], width: double.infinity, height: 180, fit: BoxFit.cover),
              ),
              const SizedBox(height: 12),
              Text(item['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(item['subtitle'], style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(item['price'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 123, 0)),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item['title']} сагсанд нэмэгдлээ')),
                    );
                  },
                  child: const Text('Сагсанд нэмэх'),
                ),
              ]),
              const SizedBox(height: 16),
            ]),
          ),
        );
      },
    );
  }

  // ---------------- CREATE BAG ----------------
  void _showCreateBagDialog() {
    Map<String, dynamic>? selectedPizza;
    Map<String, dynamic>? selectedDrink;
    int pizzaQty = 1;
    int drinkQty = 1;

    _bagNameCtrl.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setLocal) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Center(child: Text('Багц үүсгэх', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),

                const Text('Багцын нэр'),
                const SizedBox(height: 6),
                TextField(
                  controller: _bagNameCtrl,
                  decoration: const InputDecoration(hintText: 'Жишээ: Мини Багц', border: OutlineInputBorder()),
                ),

                const SizedBox(height: 14),
                const Text('Пицца сонгох'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: pizzas.map((p) {
                    final sel = selectedPizza == p;
                    return ChoiceChip(
                      label: Text(p['title']),
                      selected: sel,
                      onSelected: (_) => setLocal(() => selectedPizza = p),
                      selectedColor: const Color.fromARGB(255, 255, 123, 0),
                      labelStyle: TextStyle(color: sel ? Colors.white : Colors.black),
                    );
                  }).toList(),
                ),

                if (selectedPizza != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text('Пиццаны тоо: '),
                    IconButton(
                      onPressed: () {
                        if (pizzaQty > 1) setLocal(() => pizzaQty--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$pizzaQty', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => setLocal(() => pizzaQty++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ]),
                ],

                const SizedBox(height: 14),
                const Text('Ундаа сонгох'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: drinks.map((d) {
                    final sel = selectedDrink == d;
                    return ChoiceChip(
                      label: Text(d['title']),
                      selected: sel,
                      onSelected: (_) => setLocal(() => selectedDrink = d),
                      selectedColor: const Color.fromARGB(255, 255, 123, 0),
                      labelStyle: TextStyle(color: sel ? Colors.white : Colors.black),
                    );
                  }).toList(),
                ),

                if (selectedDrink != null) ...[
                  const SizedBox(height: 8),
                  Row(children: [
                    const Text('Ундааны тоо: '),
                    IconButton(
                      onPressed: () {
                        if (drinkQty > 1) setLocal(() => drinkQty--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$drinkQty', style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      onPressed: () => setLocal(() => drinkQty++),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ]),
                ],

                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 123, 0)),
                    onPressed: (_bagNameCtrl.text.isNotEmpty && selectedPizza != null && selectedDrink != null)
                        ? () {
                            final newPack = {
                              'title': _bagNameCtrl.text,
                              'subtitle':
                                  '${selectedPizza!['title']} x$pizzaQty  +  ${selectedDrink!['title']} x$drinkQty',
                              'price': '---',
                              'img': selectedPizza!['img'],
                            };

                            setState(() {
                              categories[bagIndex]['items'].add(newPack);
                              selectedCategoryIndex = bagIndex;
                            });

                            Navigator.pop(context);
                          }
                        : null,
                    child: const Text('Багц нэмэх'),
                  ),
                ),
              ]),
            ),
          );
        });
      },
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 180,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          _imageFor('assets/images/pizzahutbanner.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.18)),
          const Positioned(
            left: 16,
            bottom: 16,
            child: Text(
              'FEED\nGOOD\nTIMES',
              style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 0.95),
            ),
          ),
        ]),
      ),
    );
  }

  // ---------------- REST INFO ----------------
  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(radius: 36, backgroundImage: AssetImage('assets/images/pizzahutlogo.png')),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(
                  child: Text('Pizza Hut / 3-р хороолол',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 123, 0), borderRadius: BorderRadius.circular(12)),
                  child: const Row(children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('5', style: TextStyle(color: Colors.white))
                  ]),
                )
              ]),
              const SizedBox(height: 6),
              Row(children: const [
                Icon(Icons.schedule, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text('12:00 - 22:30', style: TextStyle(color: Colors.grey)),
                SizedBox(width: 12),
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Expanded(child: Text('3-р хороолол, Солонгос плаза', style: TextStyle(color: Colors.grey))),
              ]),
            ]),
          )
        ]),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 123, 0),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.store, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              const Text('Pizza Hut / 3-р Хороолол', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('12:00 - 22:30', style: TextStyle(color: Colors.white, fontSize: 12)),
              )
            ],
          ),
        ),
      ]),
    );
  }

  // ---------------- UI ----------------
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: const [
        Text('Food', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(width: 10),
        Expanded(child: Divider(thickness: 2)),
      ]),
    );
  }

  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, idx) {
            final name = categories[idx]['name'];
            return ChoiceChip(
              label: Text(name),
              selected: selectedCategoryIndex == idx,
              onSelected: (sel) => setState(() => selectedCategoryIndex = idx),
              selectedColor: const Color.fromARGB(255, 255, 123, 0),
              labelStyle: TextStyle(color: selectedCategoryIndex == idx ? Colors.white : Colors.black),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => _showItemDetails(item),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: _imageFor(item['img'], height: 95, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget _buildHorizontalMenu() {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filteredItems.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _buildMenuCard(filteredItems[index]),
      ),
    );
  }

  Widget _buildMenuListTile(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => _showItemDetails(item),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _imageFor(item['img'], width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(item['title']),
        subtitle: Text(item['subtitle']),
        trailing: Text(item['price']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 255, 123, 0),
        onPressed: _showCreateBagDialog,
        icon: const Icon(Icons.fastfood),
        label: const Text('Багц нэмэх'),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildRestaurantInfo()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildCategoryChips()),
            const SliverToBoxAdapter(child: SizedBox(height: 6)),
            SliverToBoxAdapter(child: _buildSectionTitle('Food')),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildHorizontalMenu()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildMenuListTile(filteredItems[index]),
                  childCount: filteredItems.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
