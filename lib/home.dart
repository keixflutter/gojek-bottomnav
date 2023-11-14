import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late List<NavigationItem> pages = [
    NavigationItem(label: 'Home', icon: Icons.home_rounded),
    NavigationItem(label: 'Food', icon: Icons.fastfood_rounded),
    NavigationItem(label: 'Pay', icon: Icons.payments_rounded),
    NavigationItem(label: 'Promo', icon: Icons.discount_rounded),
    NavigationItem(label: 'Message', icon: Icons.inbox_rounded),
  ];
  late TabController tabController = TabController(
    length: pages.length,
    vsync: this,
    animationDuration: kThemeAnimationDuration,
  );

  @override
  void initState() {
    tabController.addListener(tabListener);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  double calculateMargin(double value, double desired) {
    value = value.abs();
    return value <= 0.5 ? (value * 2 * desired) : ((1 - value) * 2 * desired);
  }

  int currentIndex = 0;
  ValueNotifier<double> indexOffset = ValueNotifier(0);

  void tabListener() {
    if (!tabController.indexIsChanging &&
        tabController.previousIndex != tabController.index) {
      currentIndex = tabController.index;
      setState(() {});
    }
  }

  // Getters
  double get screenWidth => MediaQuery.of(context).size.width;
  double get tabWidth => screenWidth / tabController.length;
  double get leftPosition =>
      (tabController.index + tabController.offset) * tabWidth;
  double get rightPosition =>
      (tabController.length -
          (tabController.index + tabController.offset + 1)) *
      tabWidth;
  double get marginValue => screenWidth / (tabController.length * 2) - 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: List.generate(
          tabController.length,
          (index) => Center(
            child: Text(
              index.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 72,
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 56,
          child: Stack(
            children: [
              /// background gradasi
              buildBackgroundGradasi(),

              /// indicator atas
              buildIndikatorAtas(),

              /// widget navigasinya
              buildNavigasi(pages),
            ],
          ),
        ),
      ),
    );
  }

  Row buildNavigasi(List<NavigationItem> pages) {
    return Row(
      children: List.generate(
        pages.length,
        (index) => SizedBox(
          height: 56,
          width: tabWidth,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                tabController.animateTo(index);
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        pages[index].icon,
                        color: tabController.index == index
                            ? Colors.green.shade900
                            : Colors.grey.shade700,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        pages[index].label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: tabController.index == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: tabController.index == index
                              ? Colors.green.shade900
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedBuilder buildIndikatorAtas() {
    return AnimatedBuilder(
      animation: tabController.animation ?? tabController,
      builder: (context, child) => Positioned(
        left: leftPosition -
            (!tabController.offset.isNegative
                ? 0
                : calculateMargin(tabController.offset, marginValue)),
        right: rightPosition -
            (tabController.offset.isNegative
                ? 0
                : calculateMargin(tabController.offset, marginValue)),
        child: SizedBox(
          height: 6,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(32), top: Radius.circular(8)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedBuilder buildBackgroundGradasi() {
    return AnimatedBuilder(
      animation: tabController.animation ?? tabController,
      builder: (context, child) => Positioned(
        left: leftPosition,
        child: Center(
          child: SizedBox(
            width: tabWidth,
            height: 56,
            child: AnimatedOpacity(
              opacity: tabController.offset == 0 ? 1 : 0,
              duration: kThemeAnimationDuration,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade700.withOpacity(.4),
                      Colors.greenAccent.shade700.withOpacity(0.1),
                      Colors.greenAccent.shade700.withOpacity(0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;

  NavigationItem({required this.label, required this.icon});
}
