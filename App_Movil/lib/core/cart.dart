import 'package:flutter/foundation.dart';
import 'models.dart';

class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (s, i) => s + i.cantidad);
  double get totalPrice => _items.fold(0.0, (s, i) => s + i.subtotal);
  bool contains(int id) => _items.any((i) => i.producto.id == id);

  void add(Producto p) {
    final idx = _items.indexWhere((i) => i.producto.id == p.id);
    if (idx >= 0) {
      _items[idx].cantidad++;
    } else {
      _items.add(CartItem(producto: p));
    }
    notifyListeners();
  }

  void remove(int id) {
    _items.removeWhere((i) => i.producto.id == id);
    notifyListeners();
  }

  void inc(int id) {
    final idx = _items.indexWhere((i) => i.producto.id == id);
    if (idx >= 0) { _items[idx].cantidad++; notifyListeners(); }
  }

  void dec(int id) {
    final idx = _items.indexWhere((i) => i.producto.id == id);
    if (idx >= 0) {
      if (_items[idx].cantidad > 1) { _items[idx].cantidad--; }
      else { _items.removeAt(idx); }
      notifyListeners();
    }
  }

  void clear() { _items.clear(); notifyListeners(); }
}
