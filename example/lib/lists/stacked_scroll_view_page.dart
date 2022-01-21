import 'package:flutter/material.dart';
import 'package:sugoi/sugoi.dart';

class StackedScrollViewPage extends StatelessWidget {
  const StackedScrollViewPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const StackedScrollViewPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StackedScrollView'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.arrow_upward_rounded),
                child: Text('Top aligned'),
              ),
              Tab(
                icon: Icon(Icons.arrow_downward_rounded),
                child: Text('Bottom aligned'),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _TopAlignedTabPage(),
            _BottomAlignedTabPage(),
          ],
        ),
      ),
    );
  }
}

class _TopAlignedTabPage extends StatelessWidget {
  const _TopAlignedTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackedScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      foregroundChild: const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
            ),
          ),
        ),
      ),
      backgroundChild: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            for (int i = 0; i < 20; i++)
              _ExampleRestaurantCard(
                index: i,
              ),
          ],
        ),
      ),
    );
  }
}

class _ExampleRestaurantCard extends StatelessWidget {
  const _ExampleRestaurantCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  static const _exampleImageUrls = [
    'https://as1.ftcdn.net/v2/jpg/02/48/92/96/1000_F_248929619_JkVBYroM1rSrshWJemrcjriggudHMUhV.jpg',
    'https://as1.ftcdn.net/v2/jpg/02/52/38/80/1000_F_252388016_KjPnB9vglSCuUJAumCDNbmMzGdzPAucK.jpg',
    'https://as2.ftcdn.net/v2/jpg/02/09/64/33/1000_F_209643310_7tdlZx6oMF9iPqnt2PzbXdfYTNKGohdm.jpg',
    'https://as1.ftcdn.net/v2/jpg/02/60/12/88/1000_F_260128861_Q2ttKHoVw2VrmvItxyCVBnEyM1852MoJ.jpg',
    'https://as2.ftcdn.net/v2/jpg/02/47/84/83/1000_F_247848348_c9xNhBpQ2aAS4UuSkz52n3BaeY6bXhmz.jpg',
  ];

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 128,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                _exampleImageUrls[index % _exampleImageUrls.length],
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Restaurant ${index + 1}',
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAlignedTabPage extends StatelessWidget {
  const _BottomAlignedTabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StackedScrollView(
      alignToTop: false,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      foregroundChild: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () {},
            child: const Center(
              child: Text('Submit'),
            ),
          ),
        ),
      ),
      backgroundChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ExampleFormField(
            label: 'First name',
            value: 'John',
          ),
          _ExampleFormField(
            label: 'Last name',
            value: 'Doe',
          ),
          _ExampleFormField(
            label: 'Email',
            value: 'johndoe@example.com',
          ),
          _ExampleFormField(
            label: 'Phone',
            value: '+1 (555) 555-5555',
          ),
          _ExampleFormField(
            label: 'Address',
            value: '123 Main St, Anywhere, USA',
          ),
        ],
      ),
    );
  }
}

class _ExampleFormField extends StatelessWidget {
  const _ExampleFormField({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
          ),
        ],
      ),
    );
  }
}
