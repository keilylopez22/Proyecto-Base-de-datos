// Controllers/GaritaController.cs
using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class GaritaController : Controller
{
    private readonly GaritaService _service;

    public GaritaController(GaritaService service)
    {
        _service = service;
    }

    public async Task<IActionResult> Index()
    {
        var garitas = await _service.ObtenerTodasAsync();
        return View(garitas);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Garita garita)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(garita);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(garita);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var garita = await _service.BuscarPorIdAsync(id);
        if (garita == null) return NotFound();

        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(garita);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Garita garita)
    {
        if (id != garita.IdGarita) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(garita);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(garita);
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