using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class PropietarioController : Controller
{
    private readonly PropietarioService _propietarioService;
    private readonly PersonaService _personaService;

    public PropietarioController(PropietarioService propietarioService, PersonaService personaService)
    {
        _propietarioService = propietarioService;
        _personaService = personaService;
    }

    // GET: Propietario
    public async Task<IActionResult> Index()
    {
        var propietarios = await _propietarioService.ObtenerTodosAsync();
        return View(propietarios);
    }

    // GET: Propietario/Create
    public async Task<IActionResult> Create()
    {
        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View();
    }

    // POST: Propietario/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Propietario propietario)
    {
        if (ModelState.IsValid)
        {
            await _propietarioService.InsertarAsync(propietario);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View(propietario);
    }

    // GET: Propietario/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var propietario = await _propietarioService.BuscarPorIdAsync(id);
        if (propietario == null) return NotFound();

        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View(propietario);
    }

    // POST: Propietario/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Propietario propietario)
    {
        if (id != propietario.IdPropietario) return BadRequest();
        if (ModelState.IsValid)
        {
            await _propietarioService.ActualizarAsync(propietario);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View(propietario);
    }

    // POST: Propietario/Delete/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _propietarioService.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}