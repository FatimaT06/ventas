class Producto {
  final int id;
  final String nombre;
  final String marca;
  final double precio;
  final int stock;
  final String descripcion;
  final String categoria;

  const Producto({
    required this.id,
    required this.nombre,
    required this.marca,
    required this.precio,
    required this.stock,
    required this.descripcion,
    required this.categoria,
  });
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
  final int unidades;
  final String nombreProducto;

  const Venta({
    required this.id,
    required this.fecha,
    required this.total,
    required this.unidades,
    required this.nombreProducto,
  });
}

final List<Producto> kProductos = [
  Producto(id: 1,  nombre: 'Intel Edison',         marca: 'Intel',            precio: 1899.00, stock: 25,  descripcion: 'Microcontrolador Intel Edison con WiFi y Bluetooth integrado. Ideal para proyectos IoT y prototipado avanzado.',         categoria: 'Microcontroladores'),
  Producto(id: 2,  nombre: 'Arduino Uno R3',        marca: 'Arduino',          precio:  549.00, stock: 40,  descripcion: 'Placa Arduino Uno R3, la favorita para proyectos de electronica educativa y profesional.',                             categoria: 'Microcontroladores'),
  Producto(id: 3,  nombre: 'Raspberry Pi 4B',       marca: 'Raspberry Pi',     precio: 1299.00, stock: 15,  descripcion: 'Raspberry Pi 4 Modelo B 4GB RAM. Mini computadora completa con conectividad dual band.',                              categoria: 'Microcontroladores'),
  Producto(id: 4,  nombre: 'Regulador LM7805',      marca: 'Texas Instruments',precio:   89.00, stock: 100, descripcion: 'Regulador de voltaje LM7805, salida fija de 5V. Esencial en fuentes de alimentacion regulada.',                      categoria: 'Componentes'),
  Producto(id: 5,  nombre: 'Resistencia 220 ohm',   marca: 'Generic',          precio:    3.50, stock: 500, descripcion: 'Resistencia 220 ohms 1/4W, ideal para limitar corriente en LEDs y circuitos digitales.',                             categoria: 'Componentes'),
  Producto(id: 6,  nombre: 'Capacitor 100uF',       marca: 'Generic',          precio:    4.00, stock: 450, descripcion: 'Capacitor electrolitico 100uF 16V para filtrado y desacoplamiento de senales en circuitos.',                          categoria: 'Componentes'),
  Producto(id: 7,  nombre: 'Transistor 2N2222',     marca: 'ON Semiconductor', precio:   12.00, stock: 200, descripcion: 'Transistor NPN 2N2222 de proposito general, ampliamente usado en conmutacion y amplificacion.',                      categoria: 'Componentes'),
  Producto(id: 8,  nombre: 'PIC16F877A',            marca: 'Microchip',        precio:   79.00, stock: 120, descripcion: 'Microcontrolador PIC16F877A de alto rendimiento con 8KB de memoria Flash y 368 bytes de RAM.',                       categoria: 'Microcontroladores'),
  Producto(id: 9,  nombre: 'Display LCD 16x2',      marca: 'Generic',          precio:   35.00, stock: 80,  descripcion: 'Display LCD 16x2 caracteres con retroiluminacion azul e interfaz paralela de 4 u 8 bits.',                           categoria: 'Pantallas'),
  Producto(id: 10, nombre: 'Sensor LM35',           marca: 'Generic',          precio:   25.00, stock: 150, descripcion: 'Sensor de temperatura LM35 con precision de mas o menos 0.5 grados Celsius y salida lineal.',                        categoria: 'Sensores'),
];

final List<Venta> kVentas = [
  Venta(id: 8,  fecha: '10 Feb 2026', total: 1899.00, unidades: 1,   nombreProducto: 'Intel Edison'),
  Venta(id: 6,  fecha: '10 Feb 2026', total: 1200.00, unidades: 48,  nombreProducto: 'Sensor LM35'),
  Venta(id: 2,  fecha: '10 Feb 2026', total: 1299.00, unidades: 1,   nombreProducto: 'Raspberry Pi 4B'),
  Venta(id: 1,  fecha: '10 Feb 2026', total:  549.00, unidades: 1,   nombreProducto: 'Arduino Uno R3'),
  Venta(id: 10, fecha: '10 Feb 2026', total:  445.00, unidades: 5,   nombreProducto: 'Regulador LM7805'),
  Venta(id: 3,  fecha: '10 Feb 2026', total:  350.00, unidades: 100, nombreProducto: 'Resistencia 220 ohm'),
  Venta(id: 4,  fecha: '10 Feb 2026', total:  240.00, unidades: 20,  nombreProducto: 'Transistor 2N2222'),
  Venta(id: 7,  fecha: '10 Feb 2026', total:  175.00, unidades: 5,   nombreProducto: 'Display LCD 16x2'),
  Venta(id: 5,  fecha: '10 Feb 2026', total:   79.00, unidades: 1,   nombreProducto: 'PIC16F877A'),
  Venta(id: 9,  fecha: '10 Feb 2026', total:   40.00, unidades: 10,  nombreProducto: 'Capacitor 100uF'),
];
