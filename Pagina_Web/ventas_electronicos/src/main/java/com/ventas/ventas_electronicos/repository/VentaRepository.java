package com.ventas.ventas_electronicos.repository;

import com.ventas.ventas_electronicos.model.Venta;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VentaRepository extends JpaRepository<Venta, Long> {
}
