import 'package:flutter/material.dart';

void main() {
  runApp(const TiendaElectronicaApp());
}

class AppColors {
  static const primary = Color(0xFFFF6B35);
  static const primaryLight = Color(0xFFFF8C5E);
  static const background = Color(0xFFF8F8F8);
  static const surface = Color(0xFFFFFFFF);
  static const textDark = Color(0xFF1A1A2E);
  static const textGrey = Color(0xFF9B9B9B);
  static const cardShadow = Color(0x14000000);
  static const badge = Color(0xFFFF3B30);
}


class Producto {
  final int id;
  final String nombre;
  final String marca;
  final double precio;
  final int stock;
  final String descripcion;
  final String emoji;
  final String categoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.precio,
    required this.stock,
    required this.descripcion,
    required this.emoji,
    required this.categoria,
  });
}

class CartItem {
  final Producto producto;
  int cantidad;

  CartItem({required this.producto, this.cantidad = 1});

  double get subtotal => producto.precio * cantidad;
}


final List<Producto> productos = [
  Producto(id: 1, nombre: 'Intel Edison', marca: 'Intel', precio: 1899.00, stock: 25, descripcion: 'Microcontrolador Intel Edison con WiFi y Bluetooth integrado.', emoji: '🔵', categoria: 'Microcontroladores'),
  Producto(id: 2, nombre: 'Arduino Uno R3', marca: 'Arduino', precio: 549.00, stock: 40, descripcion: 'Placa Arduino Uno R3, la favorita para proyectos de electrónica.', emoji: '🟢', categoria: 'Microcontroladores'),
  Producto(id: 3, nombre: 'Raspberry Pi 4B', marca: 'Raspberry Pi', precio: 1299.00, stock: 15, descripcion: 'Raspberry Pi 4 Modelo B 4GB RAM, mini computadora completa.', emoji: '🍓', categoria: 'Microcontroladores'),
  Producto(id: 4, nombre: 'Regulador LM7805', marca: 'Texas Instruments', precio: 89.00, stock: 100, descripcion: 'Regulador de voltaje LM7805, salida fija de 5V.', emoji: '⚡', categoria: 'Componentes'),
  Producto(id: 5, nombre: 'Resistencia 220Ω', marca: 'Generic', precio: 3.50, stock: 500, descripcion: 'Resistencia 220 ohms 1/4W, ideal para LEDs.', emoji: '🟡', categoria: 'Componentes'),
  Producto(id: 6, nombre: 'Capacitor 100uF', marca: 'Generic', precio: 4.00, stock: 450, descripcion: 'Capacitor electrolítico 100uF 16V.', emoji: '🔷', categoria: 'Componentes'),
  Producto(id: 7, nombre: 'Transistor 2N2222', marca: 'ON Semiconductor', precio: 12.00, stock: 200, descripcion: 'Transistor NPN 2N2222, ampliamente usado en circuitos.', emoji: '🔺', categoria: 'Componentes'),
  Producto(id: 8, nombre: 'PIC16F877A', marca: 'Microchip', precio: 79.00, stock: 120, descripcion: 'Microcontrolador PIC16F877A de alto rendimiento.', emoji: '🔴', categoria: 'Microcontroladores'),
  Producto(id: 9, nombre: 'Display LCD 16x2', marca: 'Generic', precio: 35.00, stock: 80, descripcion: 'Display LCD 16x2 caracteres con retroiluminación.', emoji: '📺', categoria: 'Pantallas'),
  Producto(id: 10, nombre: 'Sensor LM35', marca: 'Generic', precio: 25.00, stock: 150, descripcion: 'Sensor de temperatura LM35 precisión ±0.5°C.', emoji: '🌡️', categoria: 'Sensores'),
];


class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  void addItem(Producto producto) {
    final index = _items.indexWhere((i) => i.producto.id == producto.id);
    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(CartItem(producto: producto));
    }
    notifyListeners();
  }

  void removeItem(int productoId) {
    _items.removeWhere((i) => i.producto.id == productoId);
    notifyListeners();
  }

  void increment(int productoId) {
    final index = _items.indexWhere((i) => i.producto.id == productoId);
    if (index >= 0) {
      _items[index].cantidad++;
      notifyListeners();
    }
  }

  void decrement(int productoId) {
    final index = _items.indexWhere((i) => i.producto.id == productoId);
    if (index >= 0) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool contains(int productoId) =>
      _items.any((i) => i.producto.id == productoId);
}

class TiendaElectronicaApp extends StatelessWidget {
  const TiendaElectronicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        return MaterialApp(
          title: 'ElecShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'SF Pro Display',
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 12, 14, 154),
              background: AppColors.background,
            ),
          ),
          home: const MainShell(),
        );
      },
    );
  }
}

final CartNotifier _cart = CartNotifier();

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    CatalogPage(),
    CartPage(),
    VentasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 214, 211, 231),
        boxShadow: [
          BoxShadow(color: Color(0x0F000000), blurRadius: 20, offset: Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Inicio', index: 0, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.grid_view_rounded, label: 'Catálogo', index: 1, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItemCart(index: 2, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
              _NavItem(icon: Icons.receipt_long_rounded, label: 'Ventas', index: 3, selected: _selectedIndex, onTap: (i) => setState(() => _selectedIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final Function(int) onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromARGB(255, 84, 107, 207).withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? const Color.fromARGB(255, 165, 51, 247) : AppColors.textGrey, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: isSelected ? const Color.fromARGB(255, 195, 125, 100) : AppColors.textGrey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class _NavItemCart extends StatelessWidget {
  final int index;
  final int selected;
  final Function(int) onTap;

  const _NavItemCart({required this.index, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color.fromARGB(255, 40, 66, 193).withOpacity(0.12) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.shopping_bag_outlined, color: isSelected ? AppColors.primary : AppColors.textGrey, size: 22),
                    if (_cart.totalItems > 0)
                      Positioned(
                        top: -4, right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: AppColors.badge, shape: BoxShape.circle),
                          child: Text('${_cart.totalItems}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Carrito', style: TextStyle(fontSize: 10, color: isSelected ? AppColors.primary : AppColors.textGrey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
              ],
            ),
          ),
        );
      },
    );
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categorias = productos.map((p) => p.categoria).toSet().toList();
    final destacados = productos.where((p) => p.precio > 100).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [

          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20, bottom: 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bienvenido 👋', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                      Text('ElecShop', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryLight], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2))],
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 14),
                    Icon(Icons.search_rounded, color: AppColors.textGrey, size: 20),
                    SizedBox(width: 8),
                    Text('Buscar productos...', style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(right: -10, top: -10,
                      child: Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(right: 20, bottom: -20,
                      child: Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('🔥 Oferta especial', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 8),
                          const Text('Componentes\nElectrónicos', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
                          const SizedBox(height: 4),
                          const Text('Hasta 30% de descuento', style: TextStyle(color: Color(0xFF9BA4B5), fontSize: 12)),
                        ],
                      ),
                    ),
                    Positioned(right: 16, top: 0, bottom: 0,
                      child: Center(
                        child: Text('⚡', style: TextStyle(fontSize: 56)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Categorías', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  Text('Ver todo', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 84,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final icons = ['🔧', '📦', '📺', '🌡️'];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Column(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: index == 0 ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2))],
                          ),
                          child: Center(child: Text(icons[index % icons.length], style: const TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(height: 4),
                        Text(categorias[index], style: const TextStyle(fontSize: 10, color: AppColors.textGrey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Destacados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  Text('Ver todo', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: destacados.length,
                itemBuilder: (context, index) => _FeaturedCard(producto: destacados[index]),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final Producto producto;
  const _FeaturedCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(producto: producto))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Center(child: Text(producto.emoji, style: const TextStyle(fontSize: 52))),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(producto.marca, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary)),
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String? _categoriaSelected;

  List<Producto> get filtered => _categoriaSelected == null
      ? productos
      : productos.where((p) => p.categoria == _categoriaSelected).toList();

  @override
  Widget build(BuildContext context) {
    final categorias = ['Todos', ...productos.map((p) => p.categoria).toSet()];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20, bottom: 16),
              child: const Text('Catálogo', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5)),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final cat = categorias[index];
                  final isSelected = (cat == 'Todos' && _categoriaSelected == null) || cat == _categoriaSelected;
                  return GestureDetector(
                    onTap: () => setState(() => _categoriaSelected = cat == 'Todos' ? null : cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                      ),
                      child: Text(cat, style: TextStyle(color: isSelected ? Colors.white : AppColors.textGrey, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, fontSize: 13)),
                    ),
                  );
                },
              ),
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ProductCard(producto: filtered[index]),
                childCount: filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Producto producto;
  const _ProductCard({required this.producto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(producto: producto))),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Stack(
                children: [
                  Center(child: Text(producto.emoji, style: const TextStyle(fontSize: 52))),
                  Positioned(top: 8, right: 8,
                    child: ListenableBuilder(
                      listenable: _cart,
                      builder: (context, _) => Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: _cart.contains(producto.id) ? AppColors.primary : AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                        ),
                        child: Icon(_cart.contains(producto.id) ? Icons.favorite : Icons.favorite_border, color: _cart.contains(producto.id) ? Colors.white : AppColors.textGrey, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.textDark), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(producto.marca, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
                      GestureDetector(
                        onTap: () { _cart.addItem(producto); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${producto.nombre} agregado'), duration: const Duration(seconds: 1), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))); },
                        child: Container(
                          width: 26, height: 26,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(7)),
                          child: const Icon(Icons.add, color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  final Producto producto;
  const ProductDetailPage({super.key, required this.producto});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _cantidad = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Hero area
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.arrow_back_ios_rounded, size: 16, color: AppColors.textDark),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.share_outlined, size: 18, color: AppColors.textDark),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: Center(child: Text(widget.producto.emoji, style: const TextStyle(fontSize: 100))),
                  ),
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == 0 ? 20 : 6, height: 6,
                      decoration: BoxDecoration(
                        color: i == 0 ? AppColors.primary : AppColors.textGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    )),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.producto.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text('Vendedor: ${widget.producto.marca}', style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Text('\$${widget.producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(Icons.star_rounded, size: 16, color: i < 4 ? const Color(0xFFFFB800) : AppColors.textGrey.withOpacity(0.3))),
                      const SizedBox(width: 6),
                      const Text('4.2', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark)),
                      const SizedBox(width: 4),
                      Text('(${widget.producto.stock} en stock)', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: ['Descripción', 'Especificaciones', 'Reseñas'].asMap().entries.map((e) => Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: e.key == 0 ? AppColors.primary : Colors.transparent, width: 2)),
                      ),
                      child: Text(e.value, style: TextStyle(fontSize: 13, fontWeight: e.key == 0 ? FontWeight.w700 : FontWeight.w400, color: e.key == 0 ? AppColors.primary : AppColors.textGrey)),
                    )).toList(),
                  ),

                  const SizedBox(height: 12),

                  Text(widget.producto.descripcion, style: const TextStyle(fontSize: 14, color: AppColors.textGrey, height: 1.6)),

                  const SizedBox(height: 20),

                  // Categoría badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(widget.producto.categoria, style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const Text('Cantidad', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 6)],
                        ),
                        child: Row(
                          children: [
                            _QtyButton(icon: Icons.remove, onTap: () { if (_cantidad > 1) setState(() => _cantidad--); }),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Text('$_cantidad', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark)),
                            ),
                            _QtyButton(icon: Icons.add, onTap: () => setState(() => _cantidad++), filled: true),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, -4))],
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      for (int i = 0; i < _cantidad; i++) _cart.addItem(widget.producto);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('$_cantidad x ${widget.producto.nombre} al carrito'),
                        backgroundColor: AppColors.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: const Center(child: Text('Agregar al Carrito', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QtyButton({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: filled ? Colors.white : AppColors.textDark, size: 18),
    ),
  );
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _cart,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              Container(
                color: AppColors.surface,
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20, bottom: 16),
                child: Row(
                  children: [
                    const Text('Mi Carrito', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5)),
                    const Spacer(),
                    if (_cart.items.isNotEmpty)
                      GestureDetector(
                        onTap: () => _cart.clear(),
                        child: const Text('Limpiar', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ),

              if (_cart.items.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🛒', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        const Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                        const SizedBox(height: 8),
                        const Text('Agrega productos para comenzar', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _cart.items.length,
                          itemBuilder: (context, index) => _CartItemTile(item: _cart.items[index]),
                        ),
                      ),

                      // Summary
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, -4))],
                        ),
                        child: Column(
                          children: [
                            // Discount code
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE8E8E8)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 14),
                                  const Expanded(child: Text('Ingresar código de descuento', style: TextStyle(fontSize: 13, color: AppColors.textGrey))),
                                  Container(
                                    margin: const EdgeInsets.all(6),
                                    padding: const EdgeInsets.symmetric(horizontal: 14),
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                    child: const Center(child: Text('Aplicar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12))),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                                Text('\$${_cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textDark)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Envío', style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                                Text('Gratis', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2ECC71))),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark)),
                                Text('\$${_cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
                              ],
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () => _showCheckoutDialog(context),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight]),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: const Center(child: Text('Proceder al Pago', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 36),
            ),
            const SizedBox(height: 16),
            const Text('¡Confirmar Venta!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text('Total: \$${_cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('${_cart.totalItems} producto(s)', style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(border: Border.all(color: AppColors.primary), borderRadius: BorderRadius.circular(12)),
                      child: const Center(child: Text('Cancelar', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _cart.clear();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('✅ Venta registrada exitosamente'),
                        backgroundColor: Color(0xFF2ECC71),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(item.producto.emoji, style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.producto.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(item.producto.categoria, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text('\$${item.producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => _cart.removeItem(item.producto.id),
                child: const Icon(Icons.delete_outline, color: AppColors.badge, size: 18),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _QtyBtn(icon: Icons.remove, onTap: () => _cart.decrement(item.producto.id)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    ),
                    _QtyBtn(icon: Icons.add, onTap: () => _cart.increment(item.producto.id), filled: true),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QtyBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: Icon(icon, color: filled ? Colors.white : AppColors.textDark, size: 14),
    ),
  );
}

class VentasPage extends StatelessWidget {
  const VentasPage({super.key});

  static final List<Map<String, dynamic>> _ventas = [
    {'id': 8, 'fecha': '10 Feb 2026', 'total': 1899.00, 'items': 1, 'producto': 'Intel Edison', 'emoji': '🔵'},
    {'id': 6, 'fecha': '10 Feb 2026', 'total': 1200.00, 'items': 48, 'producto': 'Sensor LM35', 'emoji': '🌡️'},
    {'id': 2, 'fecha': '10 Feb 2026', 'total': 1299.00, 'items': 1, 'producto': 'Raspberry Pi 4B', 'emoji': '🍓'},
    {'id': 1, 'fecha': '10 Feb 2026', 'total': 549.00, 'items': 1, 'producto': 'Arduino Uno R3', 'emoji': '🟢'},
    {'id': 10, 'fecha': '10 Feb 2026', 'total': 445.00, 'items': 5, 'producto': 'Regulador LM7805', 'emoji': '⚡'},
    {'id': 3, 'fecha': '10 Feb 2026', 'total': 350.00, 'items': 100, 'producto': 'Resistencia 220Ω', 'emoji': '🟡'},
    {'id': 4, 'fecha': '10 Feb 2026', 'total': 240.00, 'items': 20, 'producto': 'Transistor 2N2222', 'emoji': '🔺'},
    {'id': 7, 'fecha': '10 Feb 2026', 'total': 175.00, 'items': 5, 'producto': 'Display LCD 16x2', 'emoji': '📺'},
    {'id': 5, 'fecha': '10 Feb 2026', 'total': 79.00, 'items': 1, 'producto': 'PIC16F877A', 'emoji': '🔴'},
    {'id': 9, 'fecha': '10 Feb 2026', 'total': 40.00, 'items': 10, 'producto': 'Capacitor 100uF', 'emoji': '🔷'},
  ];

  double get _totalVentas => _ventas.fold(0.0, (sum, v) => sum + (v['total'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12, left: 20, right: 20, bottom: 16),
              child: const Text('Historial de Ventas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Ventas',
                      value: '\$${_totalVentas.toStringAsFixed(0)}',
                      icon: '💰',
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Transacciones',
                      value: '${_ventas.length}',
                      icon: '📊',
                      color: const Color(0xFF6C63FF),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Row(
                children: [
                  const Text('Recientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Hoy', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _VentaTile(venta: _ventas[index], index: index),
              childCount: _ventas.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, icon;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const Spacer(),
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
      ],
    ),
  );
}

class _VentaTile extends StatelessWidget {
  final Map<String, dynamic> venta;
  final int index;
  const _VentaTile({required this.venta, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(venta['emoji'], style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venta['producto'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text('${venta['items']} unidad(es) • ${venta['fecha']}', style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${(venta['total'] as double).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.primary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Completado', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}