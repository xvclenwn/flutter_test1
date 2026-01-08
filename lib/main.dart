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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RestaurantPage(),
    );
  }
}

class RestaurantPage extends StatelessWidget {
  RestaurantPage({super.key});

  // fake menu data (backend байхгүй үед)
  final List<Map<String, dynamic>> menuItems = List.generate(8, (i) {
    return {
      'title': i % 2 == 0 ? 'Найзуудад Багц' : 'Хос Пицца - Супер',
      'subtitle': i % 2 == 0 ? 'BBQ / Пеперонити' : 'Хавай / Маханд дурлагсад',
      'price': '${50 + i * 2},000₮',
      'img': 'https://picsum.photos/seed/pizza$i/400/300'
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildRestaurantInfo()),
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(child: _buildSectionTitle('Food')),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildHorizontalMenu(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = menuItems[index % menuItems.length];
                    return _buildMenuListTile(context, item);
                  },
                  childCount: menuItems.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 36)),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: false,
      floating: false,
      expandedHeight: 180,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/pizzahutbanner.jpg',
              fit: BoxFit.cover,
            ),
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

  // ---------------- RESTAURANT INFO ----------------

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: NetworkImage('https://picsum.photos/seed/logo/200/200'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Expanded(
                  child: Text(
                    'Pizza Hut / 3-р хороолол',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 123, 0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(children: [
                    Icon(Icons.star, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('5', style: TextStyle(color: Colors.white)),
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
                Expanded(
                  child: Text('3-р хороолол, Солонгос плаза',
                      style: TextStyle(color: Colors.grey)),
                ),
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
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.store, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            const Text('Pizza Hut / 3-р Хороолол',
                style: TextStyle(color: Colors.white)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('12:00 - 22:30',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            )
          ]),
        ),
      ]),
    );
  }

  // ---------------- SECTION TITLE ----------------

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        const Expanded(child: Divider(thickness: 2)),
      ]),
    );
  }

  // ---------------- HORIZONTAL MENU ----------------

  Widget _buildHorizontalMenu(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = menuItems[index % menuItems.length];
          return _buildMenuCard(context, item);
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: menuItems.length,
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailPage(item: item)),
        );
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(item['img'],
                height: 95, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.timer, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                const Text('1 хvн',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Text(item['price'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ]),
          )
        ]),
      ),
    );
  }

  // ---------------- VERTICAL LIST ----------------

  Widget _buildMenuListTile(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FoodDetailPage(item: item)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(item['img'],
                width: 110, height: 90, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(item['subtitle'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                const SizedBox(height: 8),
                Row(children: [
                  Text(item['price'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  _buildAddButton(),
                ]),
              ]),
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade700),
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.green.shade700),
        onPressed: () {},
      ),
    );
  }
}

// ================== DETAIL PAGE ==================

class FoodDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const FoodDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title'])),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Image.network(item['img'],
            width: double.infinity, height: 220, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item['title'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item['subtitle'], style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 16),
            Text("Үнэ: ${item['price']}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Сагсанд нэмэх"),
              ),
            )
          ]),
        )
      ]),
    );
  }
}
