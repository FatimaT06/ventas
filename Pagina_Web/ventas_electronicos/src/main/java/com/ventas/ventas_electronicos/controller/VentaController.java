package com.ventas.ventas_electronicos.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.ventas.ventas_electronicos.repository.VentaRepository;

@Controller
@RequestMapping("/ventas")
public class VentaController {

    @Autowired
    private VentaRepository repo;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("ventas", repo.findAll());
        return "ventas/lista";
    }
}
