import 'package:flutter/material.dart';

void main() => runApp(const RestaurantDemoApp());

class RestaurantDemoApp extends StatelessWidget {
  const RestaurantDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
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
  final ScrollController _menuScrollController = ScrollController();

  // --- CATEGORIES + ITEMS DATA STRUCTURE ---
  // Add categories or items here. Each item 'img' can be an asset path (assets/...) or a network URL (https://...)
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
      'items': [
        {
          'title': 'Найзуудад Багц',
          'subtitle': 'BBQ / Пеперони',
          'price': '75,000₮',
          'img': 'assets/images/pack1.jpg'
        },
      ],
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

  void _scrollLeft() {
    final newOffset = (_menuScrollController.offset - 220).clamp(
      0.0,
      _menuScrollController.position.hasPixels
          ? _menuScrollController.position.maxScrollExtent
          : double.infinity,
    );
    _menuScrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    final max = _menuScrollController.position.hasPixels
        ? _menuScrollController.position.maxScrollExtent
        : 1000.0;
    final newOffset = (_menuScrollController.offset + 220).clamp(
      0.0,
      max,
    );
    _menuScrollController.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _menuScrollController.dispose();
    super.dispose();
  }

  // --- utility: returns an Image widget that supports asset or network paths ---
  Widget _imageFor(String path, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (path.startsWith('http')) {
      return Image.network(path, width: width, height: height, fit: fit);
    } else {
      return Image.asset(path, width: width, height: height, fit: fit);
    }
  }

  void _showFoodDetail(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.65,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 6),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _imageFor(
                              item['img'],
                              width: double.infinity,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                item['price'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(item['subtitle'] ?? '', style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 14),
                          const Text('Дэлгэрэнгүй мэдээлэл', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          const Text(
                            'Энэхүү багц нь шинэхэн орцтой, халуун, амттай пиццануудыг багтаасан. Найзууд болон гэр бүлд тохиромжтой. Тослог багатай сонголт, нэмэлт орц залгах боломжтой.',
                            style: TextStyle(height: 1.5),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              _QuantitySelector(),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Сагсанд нэмэх'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 255, 123, 0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${item['title']} сагсанд нэмлээ')),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text('Хэмжээ, орц өөрчлөхийг хүсвэл сэтгэгдэл бичнэ үү.', style: TextStyle(color: Colors.grey, fontSize: 12))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      expandedHeight: 180,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            _imageFor('assets/images/pizzahutbanner.jpg', fit: BoxFit.cover),
            Container(color: Colors.black.withOpacity(0.18)),
            const Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                'FEED\nGOOD\nTIMES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 0.95,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: AssetImage('assets/images/pizzahutlogo.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(
                  child: Text('Pizza Hut / 3-р хороолол', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 123, 0), borderRadius: BorderRadius.circular(12)),
                  child: const Row(children: [Icon(Icons.star, color: Colors.white, size: 14), SizedBox(width: 4), Text('5', style: TextStyle(color: Colors.white))]),
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
          decoration: BoxDecoration(color: const Color.fromARGB(255, 255, 123, 0), borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.store, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text('Pizza Hut / 3-р Хороолол', style: TextStyle(color: Colors.white)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(6)),
              child: const Text('12:00 - 22:30', style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ]),
        ),
      ]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        const Expanded(child: Divider(thickness: 2)),
      ]),
    );
  }

  // ---------------- CATEGORY CHIPS ----------------
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
              onSelected: (sel) {
                if (sel) {
                  setState(() {
                    selectedCategoryIndex = idx;
                    // reset horizontal menu scroll so user starts from left
                    _menuScrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  });
                }
              },
              selectedColor: const Color.fromARGB(255, 255, 123, 0),
              labelStyle: TextStyle(color: selectedCategoryIndex == idx ? Colors.white : Colors.black),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalMenu() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          ListView.separated(
            controller: _menuScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            scrollDirection: Axis.horizontal,
            itemCount: filteredItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return _buildMenuCard(filteredItems[index]);
            },
          ),
          Positioned(left: 6, top: 55, child: _arrow(Icons.chevron_left, _scrollLeft)),
          Positioned(right: 6, top: 55, child: _arrow(Icons.chevron_right, _scrollRight)),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: IconButton(icon: Icon(icon, size: 28), onPressed: onTap),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showFoodDetail(context, item),
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
          Padding(padding: const EdgeInsets.all(8), child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold))),
        ]),
      ),
    );
  }

  Widget _buildMenuListTile(BuildContext context, Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () => _showFoodDetail(context, item),
        leading: ClipRRect(borderRadius: BorderRadius.circular(6), child: _imageFor(item['img'], width: 60, height: 60, fit: BoxFit.cover)),
        title: Text(item['title']),
        subtitle: Text(item['subtitle']),
        trailing: Text(item['price']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildRestaurantInfo()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // category chips
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
                  (context, index) {
                    return _buildMenuListTile(context, filteredItems[index]);
                  },
                  childCount: filteredItems.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

// small quantity selector widget used inside the popup
class _QuantitySelector extends StatefulWidget {
  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.remove), onPressed: qty > 1 ? () => setState(() => qty--) : null),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(qty.toString(), style: const TextStyle(fontSize: 16))),
          IconButton(padding: EdgeInsets.zero, constraints: const BoxConstraints(), icon: const Icon(Icons.add), onPressed: () => setState(() => qty++)),
        ],
      ),
    );
  }
}
