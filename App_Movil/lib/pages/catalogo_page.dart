import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../shell/shell.dart';
import '../widgets/shared.dart';
import 'detalle_page.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _State();
}

class _State extends State<CatalogoPage> {
  String? _cat;

  List<Producto> get _list =>
      _cat == null ? kProductos : kProductos.where((p) => p.categoria == _cat).toList();

  List<String> get _cats =>
      ['Todos', ...kProductos.map((p) => p.categoria).toSet()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PageHeader(
              title: 'Catalogo',
              action: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.tune_rounded, size: 17, color: C.black),
              ),
            ),
          ),

          SliverToBoxAdapter(child: _Chips(cats: _cats, selected: _cat, onSelect: (v) => setState(() => _cat = v))),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _Card(producto: _list[i]),
                childCount: _list.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  final List<String> cats;
  final String? selected;
  final void Function(String?) onSelect;

  const _Chips({required this.cats, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        itemCount: cats.length,
        itemBuilder: (_, i) {
          final cat = cats[i];
          final on = (cat == 'Todos' && selected == null) || cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat == 'Todos' ? null : cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: on ? C.black : C.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: on ? C.black : C.border),
              ),
              child: Text(cat, style: TextStyle(color: on ? C.white : C.grey, fontWeight: on ? FontWeight.w600 : FontWeight.w400, fontSize: 12)),
            ),
          );
        },
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Producto producto;
  const _Card({required this.producto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetallePage(producto: producto))),
      child: Container(
        decoration: BoxDecoration(color: C.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: C.border)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: C.lightGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Center(child: Icon(iconForCat(producto.categoria), size: 42, color: C.black.withOpacity(0.11))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: C.black), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(producto.marca, style: const TextStyle(fontSize: 10, color: C.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${producto.precio.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: C.black)),
                      ListenableBuilder(
                        listenable: cart,
                        builder: (_, __) => GestureDetector(
                          onTap: () {
                            cart.add(producto);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${producto.nombre} agregado'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: C.black,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ));
                          },
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: cart.contains(producto.id) ? C.black : C.lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              cart.contains(producto.id) ? Icons.check : Icons.add,
                              size: 14,
                              color: cart.contains(producto.id) ? C.white : C.black,
                            ),
                          ),
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
