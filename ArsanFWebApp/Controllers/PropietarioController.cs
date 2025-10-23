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

    
    public async Task<IActionResult> Index(
        string? EstadoFilter,
        string? NombreFilter,
        int pageIndex = 1,
        int pageSize = 10)
        
    {
        var (items, totalCount) = await _propietarioService.ObtenerTodosAsync(pageIndex, pageSize,EstadoFilter, NombreFilter);


            

        var paginatedList = new PaginatedList<Propietario>(items, totalCount, pageIndex, pageSize);
        
        ViewBag.EstadoFilter = EstadoFilter;
        ViewBag.NombreFilter = NombreFilter;
        ViewBag.PageSize = pageSize;
        return View(paginatedList);
        
    }

    public async Task<IActionResult> Create()
    {
        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View();
    }

   
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

 
    public async Task<IActionResult> Edit(int id)
    {
        var propietario = await _propietarioService.BuscarPorIdAsync(id);
        if (propietario == null) return NotFound();

        ViewBag.Personas = await _personaService.ObtenerTodasAsync();
        return View(propietario);
    }

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

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _propietarioService.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}