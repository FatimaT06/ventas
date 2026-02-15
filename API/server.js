require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./db');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/productos', async (req, res) => {
    try {
        const [rows] = await db.query("SELECT * FROM productos");
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.post('/comprar', async (req, res) => {
    const { carrito } = req.body;

    if (!carrito || carrito.length === 0) {
        return res.status(400).json({ error: "Carrito vacío" });
    }

    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();
        let total = 0;

        for (let item of carrito) {
        const [producto] = await connection.query(
            "SELECT * FROM productos WHERE id_producto = ?",
            [item.id_producto]
        );

        if (producto.length === 0) {
            throw new Error("Producto no existe");
        }

        if (producto[0].stock < item.cantidad) {
            throw new Error(`Stock insuficiente para ${producto[0].nombre}`);
        }

        total += producto[0].precio * item.cantidad;
        }

        const [venta] = await connection.query(
        "INSERT INTO ventas (total) VALUES (?)",
        [total]
        );

        const idVenta = venta.insertId;

        for (let item of carrito) {
        const [producto] = await connection.query(
            "SELECT * FROM productos WHERE id_producto = ?",
            [item.id_producto]
        );

        const subtotal = producto[0].precio * item.cantidad;

        await connection.query(
            "INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal) VALUES (?, ?, ?, ?, ?)",
            [idVenta, item.id_producto, item.cantidad, producto[0].precio, subtotal]
        );

        await connection.query(
            "UPDATE productos SET stock = stock - ? WHERE id_producto = ?",
            [item.cantidad, item.id_producto]
        );
        }

        await connection.commit();

        res.json({
        mensaje: "Compra realizada correctamente",
        idVenta
        });

    } catch (error) {
        await connection.rollback();
        res.status(400).json({ error: error.message });
    } finally {
        connection.release();
        }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
    console.log("Servidor corriendo en puerto " + PORT);
});
