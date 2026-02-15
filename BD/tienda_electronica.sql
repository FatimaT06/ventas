-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-02-2026 a las 05:28:46
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `tienda_electronica`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL,
  `marca` varchar(255) DEFAULT NULL,
  `precio` double NOT NULL,
  `stock` int(11) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `imagen` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `marca`, `precio`, `stock`, `descripcion`, `imagen`) VALUES
(1, 'Laptop HP 15\"', 'HP', 13200, 8, 'Laptop Intel i5, 8GB RAM, 512GB SSD', 'https://mx-media.hptiendaenlinea.com/catalog/product/cache/b3b166914d87ce343d4dc5ec5117b502/7/y/7y9b0la.png'),
(2, 'Mouse Inalámbrico M185', 'Logitech', 299, 45, 'Mouse inalámbrico USB color negro', 'https://m.media-amazon.com/images/I/61TjXszTyeL.jpg'),
(3, 'Teclado Mecánico K552', 'Redragon', 1199, 20, 'Teclado mecánico RGB switches azules', 'https://m.media-amazon.com/images/I/61j-z3qH4CL._AC_UF894,1000_QL80_.jpg'),
(4, 'Monitor 24\" LED', 'Samsung', 3150, 12, 'Monitor Full HD 75Hz HDMI', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSexmnjQ61KgsbNV1WM5aggagjnD8C6hK4CEg&s'),
(5, 'Disco Duro 1TB', 'Seagate', 1450, 18, 'Disco duro externo USB 3.0', 'https://m.media-amazon.com/images/I/51TfwWlcluL._AC_SY355_.jpg'),
(6, 'Audífonos Bluetooth WH-CH520', 'Sony', 980, 25, 'Audífonos inalámbricos batería 50h', 'https://m.media-amazon.com/images/I/41lArSiD5hL._AC_UF1000,1000_QL80_.jpg'),
(7, 'Tablet Galaxy Tab A8', 'Samsung', 5200, 10, 'Tablet 10.5 pulgadas 64GB', 'https://m.media-amazon.com/images/I/71g9X7W9K3L.jpg'),
(8, 'Memoria USB 64GB', 'Kingston', 180, 100, 'USB 3.2 alta velocidad', 'https://www.officedepot.com.mx/medias/64779.gif-1200ftw?context=bWFzdGVyfHJvb3R8MTIzODQyfGltYWdlL2pwZWd8YURZeUwyaGtNQzg1TkRFMk5qRTFPREl4TXpReUxtcHdad3wzNDBmZjBmZTRjOTc1ZGM3MGMyZGI2MzI0MzAwMTMwYzI1ODEwZjEyNGNjM2I3MjQwMTQ5MTcwZjQyZjI3Zjdm'),
(9, 'Impresora Multifuncional L3250', 'Epson', 4200, 7, 'Impresora tinta continua WiFi', 'https://mediaserver.goepson.com/ImConvServlet/imconv/19149835d19c96e7a8926f68cbf4822e506a73c2/515Wx515H?use=productpictures&hybrisId=B2C&assetDescr=L3250_SPT_C11CJ67301_384x286'),
(10, 'Webcam HD 1080p', 'Logitech', 850, 30, 'Cámara web Full HD con micrófono', 'https://m.media-amazon.com/images/I/81-rvqTiJnL.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `fecha` varchar(255) DEFAULT NULL,
  `total` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `fecha`, `total`) VALUES
(1, '2026-02-10', 13200),
(2, '2026-02-10', 598),
(3, '2026-02-10', 3150),
(4, '2026-02-10', 1450),
(5, '2026-02-11', 980),
(6, '2026-02-12', 5200),
(7, '2026-02-12', 360),
(8, '2026-02-12', 8400),
(9, '2026-02-13', 850),
(10, '2026-02-13', 1199);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
