import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../widgets/shared.dart';

class VentasPage extends StatelessWidget {
  const VentasPage({super.key});

  double get _total => kVentas.fold(0.0, (s, v) => s + v.total);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: const PageHeader(title: 'Ventas')),
          SliverToBoxAdapter(child: _Stats(total: _total, count: kVentas.length)),
          SliverToBoxAdapter(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: SectionLabel(text: 'Historial reciente', linkText: 'Exportar'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: _VRow(venta: kVentas[i]),
              ),
              childCount: kVentas.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  final double total;
  final int count;

  const _Stats({required this.total, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Total Ventas',
              value: '\$${total.toStringAsFixed(0)}',
              icon: Icons.attach_money_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Transacciones',
              value: '$count',
              icon: Icons.bar_chart_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: C.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, size: 18, color: C.black),
              ),
              Container(width: 7, height: 7, decoration: const BoxDecoration(color: C.black, shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: C.black,
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 11, color: C.grey)),
        ],
      ),
    );
  }
}

class _VRow extends StatelessWidget {
  final Venta venta;
  const _VRow({required this.venta});

  IconData get _icon {
    if (venta.total > 1000) return Icons.memory_rounded;
    if (venta.total > 200)  return Icons.sensors_rounded;
    if (venta.total > 50)   return Icons.desktop_windows_rounded;
    return Icons.electrical_services_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: C.border)),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(11)),
            child: Icon(_icon, size: 20, color: C.black.withOpacity(0.18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(venta.nombreProducto, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: C.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('${venta.unidades} unid.  •  ${venta.fecha}', style: const TextStyle(fontSize: 11, color: C.grey)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${venta.total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: C.black)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(20)),
                child: const Text('Completado', style: TextStyle(color: C.black, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
