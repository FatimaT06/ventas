import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/cart.dart';
import '../pages/home_page.dart';
import '../pages/carrito_page.dart';

final cart = CartNotifier();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  static const _pages = [
    HomePage(),
    CarritoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _idx, children: _pages),
      bottomNavigationBar: _Nav(current: _idx, onTap: (i) => setState(() => _idx = i)),
    );
  }
}

class _Nav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;

  const _Nav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: C.white,
        border: Border(top: BorderSide(color: C.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              _Item(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Inicio',
                idx: 0,
                current: current,
                onTap: onTap,
              ),
              _CartItem(idx: 1, current: current, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int idx, current;
  final void Function(int) onTap;

  const _Item({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.idx,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final on = idx == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(idx),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
              decoration: BoxDecoration(
                color: on ? C.black : Colors.transparent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(on ? activeIcon : icon, size: 22, color: on ? C.white : C.grey),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                color: on ? C.black : C.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final int idx, current;
  final void Function(int) onTap;

  const _CartItem({required this.idx, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = idx == current;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(idx),
        behavior: HitTestBehavior.opaque,
        child: ListenableBuilder(
          listenable: cart,
          builder: (_, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                decoration: BoxDecoration(
                  color: on ? C.black : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      on ? Icons.shopping_bag_rounded : Icons.shopping_bag_outlined,
                      size: 22,
                      color: on ? C.white : C.grey,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        top: -5, right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: C.black, shape: BoxShape.circle),
                          child: Text(
                            '${cart.totalItems}',
                            style: const TextStyle(color: C.white, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Carrito',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                  color: on ? C.black : C.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
