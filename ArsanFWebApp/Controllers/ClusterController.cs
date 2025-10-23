using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class ClusterController : Controller
{
    private readonly ClusterService _clusterService;
    private readonly ResidencialService _residencialService;

    public ClusterController(ClusterService clusterService, ResidencialService residencialService)
    {
        _clusterService = clusterService;
        _residencialService = residencialService;
    }

    /*public async Task<IActionResult> Index()
    {
        var clusters = await _clusterService.ObtenerTodosAsync();
        return View(clusters);
    }*/

    
    public async Task<IActionResult> Index(
    string? clusterFilter,
    string? residencialFilter,
    int pageIndex = 1,
    int pageSize = 10)
{
    var (items, totalCount) = await _clusterService.ObtenerTodosAsync(
        pageIndex, pageSize, clusterFilter, residencialFilter);

    var paginatedList = new PaginatedList<Cluster>(items, totalCount, pageIndex, pageSize);

    // Pasar filtros a la vista para mantenerlos en el formulario
    ViewBag.ResidencialFilter = residencialFilter;
    ViewBag.DescripcionFilter = clusterFilter;
    ViewBag.PageSize = pageSize;

    return View(paginatedList);
}

    public async Task<IActionResult> Create()
    {
        ViewBag.Residenciales = await _residencialService.ObtenerTodosAsync();
        return View();
    }

 
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Cluster cluster)
    {
        if (ModelState.IsValid)
        {
            await _clusterService.InsertarAsync(cluster);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Residenciales = await _residencialService.ObtenerTodosAsync();
        return View(cluster);
    }

    public async Task<IActionResult> Edit(int id)
    {
        var cluster = await _clusterService.BuscarPorIdAsync(id);
        if (cluster == null) return NotFound();

        ViewBag.Residenciales = await _residencialService.ObtenerTodosAsync();
        return View(cluster);
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Cluster cluster)
    {
        if (id != cluster.IdCluster) return BadRequest();
        if (ModelState.IsValid)
        {
            await _clusterService.ActualizarAsync(cluster);
            return RedirectToAction(nameof(Index));
        }
        ViewBag.Residenciales = await _residencialService.ObtenerTodosAsync();
        return View(cluster);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _clusterService.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}