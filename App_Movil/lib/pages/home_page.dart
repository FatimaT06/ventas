import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/theme.dart';
import '../core/models.dart';
import '../shell/shell.dart';
import 'detalle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _query = '';
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

  List<Producto> get _filtered => _productos
      .where(
        (p) =>
            p.nombre.toLowerCase().contains(_query.toLowerCase()) ||
            p.marca.toLowerCase().contains(_query.toLowerCase()),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _Header()),
          SliverToBoxAdapter(
            child: _SearchBar(onChanged: (v) => setState(() => _query = v)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: Row(
                children: [
                  Text(
                    '${_filtered.length} productos',
                    style: const TextStyle(
                      fontSize: 13,
                      color: C.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
          /// LISTA
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: _ProductTile(producto: _filtered[i]),
                ),
                childCount: _filtered.length,
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'VentasApp',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: C.black,
                  letterSpacing: -0.6,
                ),
              ),
              Text(
                'Catalogo de productos',
                style: TextStyle(fontSize: 13, color: C.grey),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: C.black,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: C.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final void Function(String) onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            const Icon(Icons.search_rounded, color: C.grey, size: 19),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                style: const TextStyle(fontSize: 14, color: C.black),
                decoration: const InputDecoration(
                  hintText: 'Buscar por nombre o marca...',
                  hintStyle: TextStyle(color: C.grey, fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Producto producto;
  const _ProductTile({required this.producto});

  bool get _hayStock => producto.stock > 0;
  bool get _stockBajo => producto.stock > 0 && producto.stock <= 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetallePage(producto: producto)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        child: Row(
          children: [
            // Imagen del producto
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: C.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: producto.imagen != null && producto.imagen!.isNotEmpty
                    ? Image.network(
                        producto.imagen!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.black26,
                          size: 26,
                        ),
                      )
                    : const Icon(
                        Icons.inventory_2_outlined,
                        size: 26,
                        color: Colors.black26,
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: C.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.marca,
                    style: const TextStyle(fontSize: 12, color: C.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _hayStock ? 'Stock: ${producto.stock}' : 'Sin stock',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _hayStock
                          ? (_stockBajo ? Colors.orange : C.green)
                          : C.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: C.black,
                  ),
                ),
                const SizedBox(height: 8),
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
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: C.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add, size: 17, color: C.black),
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
