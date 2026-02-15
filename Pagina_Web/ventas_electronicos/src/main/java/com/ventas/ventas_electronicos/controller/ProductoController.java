package com.ventas.ventas_electronicos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ventas.ventas_electronicos.model.Producto;
import com.ventas.ventas_electronicos.repository.ProductoRepository;

@Controller
@RequestMapping("/productos")
public class ProductoController {

    @Autowired
    private ProductoRepository repo;

    // Ver lista de productos
    @GetMapping
    public String listar(Model model) {
        model.addAttribute("productos", repo.findAll());
        return "productos/lista";
    }

    // Mostrar formulario para nuevo producto
    @GetMapping("/nuevo")
    public String nuevo(Model model) {
        model.addAttribute("producto", new Producto());
        return "productos/formulario";
    }

    // Guardar producto nuevo o editado
    @PostMapping("/guardar")
    public String guardar(@ModelAttribute Producto producto) {
        repo.save(producto);
        return "redirect:/productos";
    }

    // Mostrar formulario para editar
    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("producto", repo.findById(id).orElseThrow());
        return "productos/formulario";
    }

    // Eliminar producto
    @GetMapping("/eliminar/{id}")
    public String eliminar(@PathVariable Long id) {
        repo.deleteById(id);
        return "redirect:/productos";
    }
}
