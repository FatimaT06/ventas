-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-02-2026 a las 01:44:43
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
-- Estructura de tabla para la tabla `detalle_venta`
--

CREATE TABLE `detalle_venta` (
  `id_detalle` int(11) NOT NULL,
  `id_venta` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_venta`
--

INSERT INTO `detalle_venta` (`id_detalle`, `id_venta`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 2, 1, 549.00, 549.00),
(2, 2, 3, 1, 1299.00, 1299.00),
(3, 3, 5, 100, 3.50, 350.00),
(4, 4, 7, 20, 12.00, 240.00),
(5, 5, 8, 1, 79.00, 79.00),
(6, 6, 10, 48, 25.00, 1200.00),
(7, 7, 9, 5, 35.00, 175.00),
(8, 8, 1, 1, 1899.00, 1899.00),
(9, 9, 6, 10, 4.00, 40.00),
(10, 10, 4, 5, 89.00, 445.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `marca` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `imagen` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `marca`, `precio`, `stock`, `descripcion`, `imagen`) VALUES
(1, 'Intel', 1899.00, 25, 'Microcontrolador Intel Edison', NULL),
(2, 'Arduino', 549.00, 40, 'Placa Arduino Uno R3', NULL),
(3, 'Raspberry Pi', 1299.00, 15, 'Raspberry Pi 4 Modelo B 4GB RAM', NULL),
(4, 'Texas Instruments', 89.00, 100, 'Regulador de voltaje LM7805', NULL),
(5, 'Generic', 3.50, 500, 'Resistencia 220 ohms 1/4W', NULL),
(6, 'Generic', 4.00, 450, 'Capacitor electrolítico 100uF 16V', NULL),
(7, 'ON Semiconductor', 12.00, 200, 'Transistor NPN 2N2222', NULL),
(8, 'Microchip', 79.00, 120, 'Microcontrolador PIC16F877A', NULL),
(9, 'Generic', 35.00, 80, 'Display LCD 16x2', NULL),
(10, 'Generic', 25.00, 150, 'Sensor de temperatura LM35', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id_venta` int(11) NOT NULL,
  `fecha` datetime DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id_venta`, `fecha`, `total`) VALUES
(1, '2026-02-10 18:43:30', 549.00),
(2, '2026-02-10 18:43:30', 1299.00),
(3, '2026-02-10 18:43:30', 350.00),
(4, '2026-02-10 18:43:30', 240.00),
(5, '2026-02-10 18:43:30', 79.00),
(6, '2026-02-10 18:43:30', 1200.00),
(7, '2026-02-10 18:43:30', 175.00),
(8, '2026-02-10 18:43:30', 1899.00),
(9, '2026-02-10 18:43:30', 70.00),
(10, '2026-02-10 18:43:30', 450.00);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_venta` (`id_venta`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id_venta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalle_venta`
--
ALTER TABLE `detalle_venta`
  ADD CONSTRAINT `detalle_venta_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `ventas` (`id_venta`),
  ADD CONSTRAINT `detalle_venta_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
