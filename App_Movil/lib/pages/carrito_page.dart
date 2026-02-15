import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../shell/shell.dart';
import '../widgets/shared.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (ctx, _) => Scaffold(
        backgroundColor: C.bg,
        body: Column(
          children: [
            PageHeader(
              title: 'Mi Carrito',
              action: cart.items.isNotEmpty
                  ? GestureDetector(
                      onTap: () => cart.clear(),
                      child: const Text('Limpiar', style: TextStyle(fontSize: 13, color: C.grey, fontWeight: FontWeight.w500)),
                    )
                  : null,
            ),
            cart.items.isEmpty ? _empty() : _content(ctx),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: C.lightGrey, shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_outlined, size: 32, color: C.grey),
            ),
            const SizedBox(height: 16),
            const Text('Tu carrito esta vacio', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: C.black)),
            const SizedBox(height: 6),
            const Text('Agrega productos para comenzar', style: TextStyle(fontSize: 13, color: C.grey)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (_, i) => _CartRow(item: cart.items[i]),
            ),
          ),
          _Summary(context),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  const _CartRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.border)),
      child: Row(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(10)),
            child: Icon(iconForCat(item.producto.categoria), size: 26, color: C.black.withOpacity(0.12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.producto.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: C.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(item.producto.categoria, style: const TextStyle(fontSize: 11, color: C.grey)),
                const SizedBox(height: 4),
                Text('\$${item.producto.precio.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: C.black)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => cart.remove(item.producto.id),
                child: const Icon(Icons.close, color: C.grey, size: 16),
              ),
              const SizedBox(height: 8),
              QtyRow(
                value: item.cantidad,
                onInc: () => cart.inc(item.producto.id),
                onDec: () => cart.dec(item.producto.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final BuildContext ctx;
  const _Summary(this.ctx);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (_, __) => Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: const BoxDecoration(color: C.white, border: Border(top: BorderSide(color: C.border))),
        child: Column(
          children: [
            _Row(label: 'Subtotal', value: '\$${cart.totalPrice.toStringAsFixed(2)}'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: C.border, height: 1),
            ),
            _Row(label: 'Total', value: '\$${cart.totalPrice.toStringAsFixed(2)}', bold: true),
            const SizedBox(height: 14),
            FilledBtn(
              label: 'Proceder al Pago',
              onTap: () => _showSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _Sheet(),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: bold ? 15 : 13, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, color: bold ? C.black : C.grey)),
        Text(value, style: TextStyle(fontSize: bold ? 16 : 13, fontWeight: bold ? FontWeight.w800 : FontWeight.w600, color: C.black)),
      ],
    );
  }
}

class _Sheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
      decoration: const BoxDecoration(color: C.white, borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: C.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: C.lightGrey, shape: BoxShape.circle),
            child: const Icon(Icons.check_rounded, color: C.black, size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Confirmar Venta', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: C.black)),
          const SizedBox(height: 6),
          ListenableBuilder(
            listenable: cart,
            builder: (_, __) => Column(
              children: [
                Text('\$${cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 15, color: C.grey, fontWeight: FontWeight.w600)),
                Text('${cart.totalItems} producto(s)', style: const TextStyle(fontSize: 13, color: C.grey)),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: FilledBtn(label: 'Cancelar', onTap: () => Navigator.pop(context), outlined: true)),
              const SizedBox(width: 12),
              Expanded(
                child: FilledBtn(
                  label: 'Confirmar',
                  onTap: () {
                    cart.clear();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Venta registrada'),
                        backgroundColor: C.black,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}