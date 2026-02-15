import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<Producto> _productos = [];
  bool _loading = true;
  String? _error;

  final String apiUrl = "https://api-production-8c3e.up.railway.app/productos";

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        setState(() {
          _productos = data.map((e) => Producto.fromJson(e)).toList();
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Error del servidor";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error de conexión";
        _loading = false;
      });
    }
  }

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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: C.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.tune_rounded, size: 17, color: C.black),
              ),
            ),
          ),

          /// LOADING
          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          /// ERROR
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  final List<String> cats;
  final String? selected;
  final void Function(String?) onSelect;

  const _Chips({
    required this.cats,
    required this.selected,
    required this.onSelect,
  });

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
              child: Text(
                cat,
                style: TextStyle(
                  color: on ? C.white : C.grey,
                  fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 12,
                ),
              ),
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetallePage(producto: producto)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: C.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: C.lightGrey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: producto.imagen.isNotEmpty
                    ? Image.network(
                        producto.imagen,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.black26,
                        ),
                      )
                    : const Icon(
                        Icons.inventory_2_outlined,
                        size: 42,
                        color: Colors.black26,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: C.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.marca,
                    style: const TextStyle(fontSize: 10, color: C.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${producto.precio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: C.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          cart.add(producto);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${producto.nombre} agregado'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: C.black,
                            ),
                          );
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: C.lightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: C.black,
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
