// Controllers/PersonaNoGrataController.cs
using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class PersonaNoGrataController : Controller
{
    private readonly PersonaNoGrataService _service;

    public PersonaNoGrataController(PersonaNoGrataService service)
    {
        _service = service;
    }

    public async Task<IActionResult> Index()
    {
        var personas = await _service.ObtenerTodasAsync();
        return View(personas);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(PersonaNoGrata persona)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        return View(persona);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var persona = await _service.BuscarPorIdAsync(id);
        if (persona == null) return NotFound();

        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        return View(persona);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, PersonaNoGrata persona)
    {
        if (id != persona.IdPersonaNoGrata) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        return View(persona);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (exito, mensaje) = await _service.EliminarAsync(id);
        TempData[exito ? "Success" : "Error"] = mensaje;
        return RedirectToAction(nameof(Index));
    }
}