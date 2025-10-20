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

  
    public async Task<IActionResult> Index()
    {
        var turnos = await _service.ObtenerTodosAsync();
        return View(turnos);
    }

  
    public IActionResult Create() => View();

   
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

    
    public async Task<IActionResult> Edit(int id)
    {
        var turno = await _service.BuscarPorIdAsync(id);
        if (turno == null) return NotFound();
        return View(turno);
    }

   
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
