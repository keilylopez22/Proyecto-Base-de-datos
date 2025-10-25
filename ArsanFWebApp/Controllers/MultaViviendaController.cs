using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ArsanWebApp.Controllers;

public class MultaViviendaController : Controller
{
    private readonly MultaViviendaService _multaService;
    private readonly TipoMultaService _tipoMultaService;
    private readonly ClusterService _clusterService;

    public MultaViviendaController(MultaViviendaService multaService, TipoMultaService tipoMultaService, ClusterService clusterService)
    {
        _multaService = multaService;
        _tipoMultaService = tipoMultaService;
        _clusterService = clusterService;
    }

    public async Task<IActionResult> Index(int pageIndex = 1, int pageSize = 10,
        string? multaViviendaFilter = null, string? tipoMultaFilter = null,
        int? numeroViviendaFilter = null, int? clusterFilter = null)
    {
        var (lista, totalCount) = await _multaService.ListarAsync(pageIndex, pageSize, multaViviendaFilter, tipoMultaFilter, numeroViviendaFilter, clusterFilter);
        ViewBag.PageIndex = pageIndex;
        ViewBag.PageSize = pageSize;
        ViewBag.TotalCount = totalCount;
        ViewBag.MultaViviendaFilter = multaViviendaFilter;
        ViewBag.TipoMultaFilter = tipoMultaFilter;
        ViewBag.NumeroViviendaFilter = numeroViviendaFilter;
        ViewBag.ClusterFilter = clusterFilter;
        return View(lista);
    }

    public async Task<IActionResult> Create()
    {
        var lista = await _tipoMultaService.ListarAsync();
        Console.WriteLine("Lista de Tipos de Multa:" + lista.Count);
        ViewBag.TiposMulta = lista;
        ViewBag.Clusters = await _clusterService.ListarAsync();
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Create(MultaVivienda m)
    {
        if (ModelState.IsValid)
        {
            await _multaService.InsertarAsync(m);
            return RedirectToAction(nameof(Index));
        }
        var lista = await _tipoMultaService.ListarAsync();
        Console.WriteLine("Lista de Tipos de Multa:" + lista.Count);
        ViewBag.TiposMulta = new SelectList(await _tipoMultaService.ListarAsync(), "IdTipoMulta", "Nombre", m.IdTipoMulta);

        ViewBag.Clusters = new SelectList(await _clusterService.ListarAsync(), "IdCluster", "Descripcion", m.IdCluster);
        return View(m);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var m = await _multaService.BuscarPorIdAsync(id);
        if (m == null) return NotFound();
        ViewBag.TiposMulta = new SelectList(await _tipoMultaService.ListarAsync(), "IdTipoMulta", "Nombre", m.IdTipoMulta);
        ViewBag.Clusters = new SelectList(await _clusterService.ListarAsync(), "IdCluster", "Descripcion", m.IdCluster);
        return View(m);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(MultaVivienda m)
    {
        if (ModelState.IsValid)
        {
            await _multaService.ActualizarAsync(m);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.TiposMulta = new SelectList(await _tipoMultaService.ListarAsync(), "IdTipoMulta", "Nombre", m.IdTipoMulta);
        ViewBag.Clusters = new SelectList(await _clusterService.ListarAsync(), "IdCluster", "Descripcion", m.IdCluster);
        return View(m);
    }

    [HttpPost]
    public async Task<IActionResult> Delete(int id)
    {
        await _multaService.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}
