class Producto {
  final int id;
  final String nombre;
  final String marca;
  final double precio;
  final int stock;
  final String descripcion;
  final String imagen;

  const Producto({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.precio,
    required this.stock,
    required this.descripcion,
    required this.imagen,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id_producto'],
      nombre: json['nombre'],
      marca: json['marca'],
      precio: double.parse(json['precio'].toString()),
      stock: json['stock'],
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
    );
  }
}

class CartItem {
  final Producto producto;
  int cantidad;
  CartItem({required this.producto, this.cantidad = 1});
  double get subtotal => producto.precio * cantidad;
}

class Venta {
  final int id;
  final String fecha;
  final double total;

  const Venta({required this.id, required this.fecha, required this.total});
}
