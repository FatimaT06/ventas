import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/models.dart';
import '../shell/shell.dart';
import '../widgets/shared.dart';

class DetallePage extends StatefulWidget {
  final Producto producto;
  const DetallePage({super.key, required this.producto});

  @override
  State<DetallePage> createState() => _State();
}

class _State extends State<DetallePage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.white,
      body: Column(
        children: [
          _buildTop(context),
          Expanded(child: _buildScroll()),
          _buildBar(context),
        ],
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    return SafeArea(
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
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: C.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 14,
                      color: C.black,
                    ),
                  ),
                ),
                const Spacer(),
                ListenableBuilder(
                  listenable: cart,
                  builder: (_, __) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: C.lightGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 18,
                          color: C.black,
                        ),
                      ),
                      if (cart.totalItems > 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              color: C.black,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${cart.totalItems}',
                                style: const TextStyle(
                                  color: C.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Aquí se muestra la imagen del producto
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: C.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  widget.producto.imagen != null &&
                      widget.producto.imagen!.isNotEmpty
                  ? Image.network(
                      widget.producto.imagen!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.black26,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 50,
                        color: Colors.black26,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == 0 ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == 0 ? C.black : C.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScroll() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
                    Text(
                      widget.producto.nombre,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: C.black,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Marca: ${widget.producto.marca}',
                      style: const TextStyle(fontSize: 12, color: C.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${widget.producto.precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: C.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const SizedBox(height: 18),

          const Divider(color: C.border, height: 1),
          const SizedBox(height: 14),

          const Text(
            'Descripcion',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: C.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.producto.descripcion,
            style: const TextStyle(fontSize: 13, color: C.grey, height: 1.7),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: C.lightGrey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              const Text(
                'Cantidad',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: C.black,
                ),
              ),
              const Spacer(),
              QtyRow(
                value: _qty,
                onInc: () => setState(() => _qty++),
                onDec: () {
                  if (_qty > 1) setState(() => _qty--);
                },
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: const BoxDecoration(
        color: C.white,
        border: Border(top: BorderSide(color: C.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: C.border, width: 1.5),
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledBtn(
              label: 'Agregar al Carrito',
              onTap: () {
                for (var i = 0; i < _qty; i++) cart.add(widget.producto);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$_qty x ${widget.producto.nombre} agregado'),
                    backgroundColor: C.black,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
