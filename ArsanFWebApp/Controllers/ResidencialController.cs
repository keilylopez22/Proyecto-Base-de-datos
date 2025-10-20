using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class ResidencialController : Controller
{
    private readonly ResidencialService _service;

    public ResidencialController(ResidencialService service)
    {
        _service = service;
    }

    
    public async Task<IActionResult> Index()
    {
        var residenciales = await _service.ObtenerTodosAsync();
        return View(residenciales);
    }

    public IActionResult Create() => View();

  
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Residencial residencial)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(residencial);
            return RedirectToAction(nameof(Index));
        }
        return View(residencial);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var residencial = await _service.BuscarPorIdAsync(id);
        if (residencial == null) return NotFound();
        return View(residencial);
    }

  
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Residencial residencial)
    {
        if (id != residencial.IdResidencial) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(residencial);
            return RedirectToAction(nameof(Index));
        }
        return View(residencial);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}