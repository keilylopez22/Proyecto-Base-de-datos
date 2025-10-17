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

    // GET: TipoVivienda
    public async Task<IActionResult> Index()
    {
        var tipos = await _service.ObtenerTodosAsync();
        return View(tipos);
    }

    // GET: TipoVivienda/Create
    public IActionResult Create() => View();

    // POST: TipoVivienda/Create
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

    // GET: TipoVivienda/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var tipo = await _service.BuscarPorIdAsync(id);
        if (tipo == null) return NotFound();
        return View(tipo);
    }

    // POST: TipoVivienda/Edit/5
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

    // POST: TipoVivienda/Delete/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}