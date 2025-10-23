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

    public async Task<IActionResult> Index()
    {
        var puestos = await _service.ObtenerTodosAsync();
        return View(puestos);
    }

    public IActionResult Create() => View();


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


    public async Task<IActionResult> Edit(int id)
    {
        var puesto = await _service.BuscarPorIdAsync(id);
        if (puesto == null) return NotFound();
        return View(puesto);
    }

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