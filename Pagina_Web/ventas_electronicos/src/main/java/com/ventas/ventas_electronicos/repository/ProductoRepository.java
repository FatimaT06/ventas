package com.ventas.ventas_electronicos.repository;

import com.ventas.ventas_electronicos.model.Producto;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductoRepository extends JpaRepository<Producto, Long> {
}
