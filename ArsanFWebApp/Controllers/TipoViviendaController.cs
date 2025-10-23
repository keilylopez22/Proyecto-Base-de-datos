using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class TipoViviendaController : Controller
{
    private readonly TipoViviendaService _service;

    public TipoViviendaController(TipoViviendaService service)
    {
        _service = service;
    }

  
    public async Task<IActionResult> Index()
    {
        var tipos = await _service.ObtenerTodosAsync();
        return View(tipos);
    }


    public IActionResult Create() => View();

    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(TipoVivienda tipo)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(tipo);
            return RedirectToAction(nameof(Index));
        }
        return View(tipo);
    }


    public async Task<IActionResult> Edit(int id)
    {
        var tipo = await _service.BuscarPorIdAsync(id);
        if (tipo == null) return NotFound();
        return View(tipo);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, TipoVivienda tipo)
    {
        if (id != tipo.IdTipoVivienda) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(tipo);
            return RedirectToAction(nameof(Index));
        }
        return View(tipo);
    }

    
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}