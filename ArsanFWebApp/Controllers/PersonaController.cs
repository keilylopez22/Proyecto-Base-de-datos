using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanFWebApp.Controllers;

public class PersonaController : Controller
{
    private readonly PersonaService _service;

    public PersonaController(PersonaService service)
    {
        _service = service;
    }

    // GET: Persona
    public async Task<IActionResult> Index()
    {
        var personas = await _service.ObtenerTodasAsync();
        return View(personas);
    }

    // GET: Persona/Create
    public IActionResult Create()
    {
        return View();
    }

    // POST: Persona/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Persona persona)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        return View(persona);
    }

    // GET: Persona/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var persona = await _service.BuscarPorIdAsync(id);
        if (persona == null) return NotFound();
        return View(persona);
    }

    // POST: Persona/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Persona persona)
    {
        if (id != persona.IdPersona) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        return View(persona);
    }

    // POST: Persona/Delete/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}