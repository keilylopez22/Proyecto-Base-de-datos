// Controllers/MiembroJuntaDirectivaController.cs
using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class MiembroJuntaDirectivaController : Controller
{
    private readonly MiembroJuntaDirectivaService _service;

    public MiembroJuntaDirectivaController(MiembroJuntaDirectivaService service)
    {
        _service = service;
    }

    public async Task<IActionResult> Index()
    {
        var miembros = await _service.ObtenerTodosAsync();
        return View(miembros);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Juntas = await _service.ObtenerJuntasDirectivasAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        ViewBag.Puestos = await _service.ObtenerPuestosAsync();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(MiembroJuntaDirectiva miembro)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(miembro);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Juntas = await _service.ObtenerJuntasDirectivasAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        ViewBag.Puestos = await _service.ObtenerPuestosAsync();
        return View(miembro);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var miembro = await _service.BuscarPorIdAsync(id);
        if (miembro == null) return NotFound();

        ViewBag.Juntas = await _service.ObtenerJuntasDirectivasAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        ViewBag.Puestos = await _service.ObtenerPuestosAsync();
        return View(miembro);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, MiembroJuntaDirectiva miembro)
    {
        if (id != miembro.IdMiembro) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(miembro);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Juntas = await _service.ObtenerJuntasDirectivasAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        ViewBag.Puestos = await _service.ObtenerPuestosAsync();
        return View(miembro);
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