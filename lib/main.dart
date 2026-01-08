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
      home: RestaurantPage(),
    );
  }
}

class RestaurantPage extends StatelessWidget {
  RestaurantPage({super.key});

  final ScrollController _menuScrollController = ScrollController();

  final List<Map<String, dynamic>> menuItems = List.generate(8, (i) {
    return {
      'title': i % 2 == 0 ? 'Найзуудад Багц' : 'Хос Пицца - Супер',
      'subtitle': i % 2 == 0 ? 'BBQ / Пеперонити' : 'Хавай / Маханд дурлагсад',
      'price': '${50 + i * 2},000₮',
      'img': 'assets/images/pizza${i % 3 + 1}.jpg'
    };
  });

  void _scrollLeft() {
    _menuScrollController.animateTo(
      _menuScrollController.offset - 220,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _menuScrollController.animateTo(
      _menuScrollController.offset + 220,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
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
            const SliverToBoxAdapter(child: SizedBox(height: 18)),
            SliverToBoxAdapter(child: _buildSectionTitle('Food')),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(child: _buildHorizontalMenu()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildMenuListTile(context, menuItems[index]);
                  },
                  childCount: menuItems.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------

  Widget _buildHeader() {
    return SliverAppBar(
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
                  child: Text(
                    'Pizza Hut / 3-р хороолол',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                Text('12:00 - 22:30',
                    style: TextStyle(color: Colors.grey)),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        const Expanded(child: Divider(thickness: 2)),
      ]),
    );
  }

  // ---------------- HORIZONTAL MENU + ARROWS ----------------

  Widget _buildHorizontalMenu() {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          ListView.separated(
            controller: _menuScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            scrollDirection: Axis.horizontal,
            itemCount: menuItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return _buildMenuCard(menuItems[index]);
            },
          ),
          Positioned(
            left: 6,
            top: 55,
            child: _arrow(Icons.chevron_left, _scrollLeft),
          ),
          Positioned(
            right: 6,
            top: 55,
            child: _arrow(Icons.chevron_right, _scrollRight),
          ),
        ],
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: IconButton(
        icon: Icon(icon, size: 28),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.asset(
            item['img'],
            height: 95,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(item['title'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }

  // ---------------- VERTICAL LIST ----------------

  Widget _buildMenuListTile(BuildContext context, Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Image.asset(item['img'], width: 60, fit: BoxFit.cover),
        title: Text(item['title']),
        subtitle: Text(item['subtitle']),
        trailing: Text(item['price']),
      ),
    );
  }
}
