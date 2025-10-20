using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class JuntaDirectivaController : Controller
{
    private readonly JuntaDirectivaService _service;

    public JuntaDirectivaController(JuntaDirectivaService service)
    {
        _service = service;
    }
    public async Task<IActionResult> Index()
    {
        var juntas = await _service.ObtenerTodasAsync();
        return View(juntas);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View();
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(JuntaDirectiva junta)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(junta);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(junta);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var junta = await _service.BuscarPorIdAsync(id);
        if (junta == null) return NotFound();

        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(junta);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, JuntaDirectiva junta)
    {
        if (id != junta.IdJuntaDirectiva) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(junta);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        return View(junta);
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