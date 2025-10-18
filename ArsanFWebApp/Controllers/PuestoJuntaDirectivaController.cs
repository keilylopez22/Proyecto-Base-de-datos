using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class PuestoJuntaDirectivaController : Controller
{
    private readonly PuestoJuntaDirectivaService _service;

    public PuestoJuntaDirectivaController(PuestoJuntaDirectivaService service)
    {
        _service = service;
    }

    // GET: PuestoJuntaDirectiva
    public async Task<IActionResult> Index()
    {
        var puestos = await _service.ObtenerTodosAsync();
        return View(puestos);
    }

    // GET: PuestoJuntaDirectiva/Create
    public IActionResult Create() => View();

    // POST: PuestoJuntaDirectiva/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(PuestoJuntaDirectiva puesto)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(puesto);
            return RedirectToAction(nameof(Index));
        }
        return View(puesto);
    }

    // GET: PuestoJuntaDirectiva/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var puesto = await _service.BuscarPorIdAsync(id);
        if (puesto == null) return NotFound();
        return View(puesto);
    }

    // POST: PuestoJuntaDirectiva/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, PuestoJuntaDirectiva puesto)
    {
        if (id != puesto.IdPuesto) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(puesto);
            return RedirectToAction(nameof(Index));
        }
        return View(puesto);
    }

    // POST: PuestoJuntaDirectiva/Delete/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (exito, mensaje) = await _service.EliminarAsync(id);
        if (!exito)
        {
            TempData["Error"] = mensaje;
        }
        return RedirectToAction(nameof(Index));
    }
}