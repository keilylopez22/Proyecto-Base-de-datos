using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class TurnoController : Controller
{
    private readonly TurnoService _service;

    public TurnoController(TurnoService service)
    {
        _service = service;
    }

    // GET: Turno
    public async Task<IActionResult> Index()
    {
        var turnos = await _service.ObtenerTodosAsync();
        return View(turnos);
    }

    // GET: Turno/Create
    public IActionResult Create() => View();

    // POST: Turno/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Turno turno)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(turno);
            return RedirectToAction(nameof(Index));
        }
        return View(turno);
    }

    // GET: Turno/Edit/5
    public async Task<IActionResult> Edit(int id)
    {
        var turno = await _service.BuscarPorIdAsync(id);
        if (turno == null) return NotFound();
        return View(turno);
    }

    // POST: Turno/Edit/5
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Turno turno)
    {
        if (id != turno.IdTurno) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(turno);
            return RedirectToAction(nameof(Index));
        }
        return View(turno);
    }

    // POST: Turno/Delete/5
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
