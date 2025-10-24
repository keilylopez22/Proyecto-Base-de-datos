// Controllers/ResidenteController.cs
using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Services;
using ArsanWebApp.Models;

namespace ArsanWebApp.Controllers;

public class ResidenteController : Controller
{
    private readonly ResidenteService _service;

    public ResidenteController(ResidenteService service)
    {
        _service = service;
    }

   
    public async Task<IActionResult> Index(
        string? nombreFilter,
        bool? esInquilinoFilter,
        string? estadoFilter,
        string? clusterFilter,
        int? numeroViviendaFilter,
        string? generoFilter,
        int pageIndex = 1,
        int pageSize = 10)
    {
        var (items, totalCount) = await _service.ObtenerResidentesAsync(
            pageIndex,
            pageSize,
            nombreFilter,
            esInquilinoFilter,
            estadoFilter,
            clusterFilter,
            numeroViviendaFilter,
            generoFilter);

        var paginatedList = new PaginatedList<Residente>(items, totalCount, pageIndex, pageSize);

        ViewBag.NombreFilter = nombreFilter;
        ViewBag.EsInquilinoFilter = esInquilinoFilter;
        ViewBag.EstadoFilter = estadoFilter;
        ViewBag.ClusterFilter = clusterFilter;
        ViewBag.NumeroViviendaFilter = numeroViviendaFilter;
        ViewBag.GeneroFilter = generoFilter;
        ViewBag.PageSize = pageSize;

        return View(paginatedList);
    }

  
    public async Task<IActionResult> Create()
    {
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        ViewBag.Viviendas = await _service.ObtenerViviendasAsync();
        return View();
    }

 
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Residente residente)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(residente);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        ViewBag.Viviendas = await _service.ObtenerViviendasAsync();
        return View(residente);
    }

    
    public async Task<IActionResult> Edit(int id)
    {
        var residente = await _service.BuscarPorIdAsync(id);
        if (residente == null)
            return NotFound();

        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        ViewBag.Viviendas = await _service.ObtenerViviendasAsync();
        return View(residente);
    }

   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Residente residente)
    {
        if (id != residente.IdResidente)
            return BadRequest();

        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(residente);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Personas = await _service.ObtenerPersonasAsync();
        ViewBag.Viviendas = await _service.ObtenerViviendasAsync();
        return View(residente);
    }

   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}