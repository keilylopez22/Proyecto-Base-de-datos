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

    // GET: Residencial
    public async Task<IActionResult> Index()
    {
        var residenciales = await _service.ObtenerTodosAsync();
        return View(residenciales);
    }

    // GET: Residencial/Create
    public IActionResult Create() => View();

    // POST: Residencial/Create
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

    // GET: Residencial/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var residencial = await _service.BuscarPorIdAsync(id);
        if (residencial == null) return NotFound();
        return View(residencial);
    }

    // POST: Residencial/Edit/5
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

    // POST: Residencial/Delete/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}