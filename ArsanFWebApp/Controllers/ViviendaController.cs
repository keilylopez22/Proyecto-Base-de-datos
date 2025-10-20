using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class ViviendaController : Controller
{
    private readonly ViviendaService _service;

    public ViviendaController(ViviendaService service)
    {
        _service = service;
    }

  
    public async Task<IActionResult> Index()
    {
        var viviendas = await _service.ObtenerTodasAsync();
        return View(viviendas);
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        ViewBag.TiposVivienda = await _service.ObtenerTiposViviendaAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Vivienda vivienda)
    {
        if (ModelState.IsValid)
        {
            try
            {
                await _service.InsertarAsync(vivienda);
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "Error al crear la vivienda: " + ex.Message);
            }
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        ViewBag.TiposVivienda = await _service.ObtenerTiposViviendaAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        return View(vivienda);
    }

    public async Task<IActionResult> Edit(int numeroVivienda, int idCluster)
    {
        var vivienda = await _service.BuscarPorClaveAsync(numeroVivienda, idCluster);
        if (vivienda == null) return NotFound();

        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        ViewBag.TiposVivienda = await _service.ObtenerTiposViviendaAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        return View(vivienda);
    }

 
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(Vivienda vivienda)
    {
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(vivienda);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Clusters = await _service.ObtenerClustersAsync();
        ViewBag.TiposVivienda = await _service.ObtenerTiposViviendaAsync();
        ViewBag.Propietarios = await _service.ObtenerPropietariosAsync();
        return View(vivienda);
    }

 
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int numeroVivienda, int idCluster)
    {
        var (exito, mensaje) = await _service.EliminarAsync(numeroVivienda, idCluster);
        if (!exito)
        {
            TempData["Error"] = mensaje;
        }
        return RedirectToAction(nameof(Index));
    }
}