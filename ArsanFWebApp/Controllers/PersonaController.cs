using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanFWebApp.Controllers;

public class PersonaController : Controller
{
    private readonly PersonaService _service;

    public PersonaController(PersonaService service)
    {
        _service = service;
    }


    /*public async Task<IActionResult> Index()
    {
        var personas = await _service.ObtenerTodasAsync();
        return View(personas);
    }*/

    public async Task<IActionResult> Index(
    string? cuiFilter,
    string? nombreFilter,
    int pageIndex = 1,
    int pageSize = 10)
{
    var (personas, totalCount) = await _service.ObtenerPersonasPaginadoAsync(
        pageIndex, pageSize, cuiFilter, nombreFilter);

    var paginatedList = new PaginatedList<Persona>(personas, totalCount, pageIndex, pageSize);

    // Pasar filtros a la vista para mantenerlos en el formulario
    ViewBag.CuiFilter = cuiFilter;
    ViewBag.NombreFilter = nombreFilter;
    ViewBag.PageSize = pageSize;

    return View(paginatedList);
}

 
    public IActionResult Create()
    {
        return View();
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Persona persona)
    {
        if (ModelState.IsValid)
        {
            await _service.InsertarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        return View(persona);
    }


    public async Task<IActionResult> Edit(int id)
    {
        var persona = await _service.BuscarPorIdAsync(id);
        if (persona == null) return NotFound();
        return View(persona);
    }

   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Persona persona)
    {
        if (id != persona.IdPersona) return BadRequest();
        if (ModelState.IsValid)
        {
            await _service.ActualizarAsync(persona);
            return RedirectToAction(nameof(Index));
        }
        return View(persona);
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        await _service.EliminarAsync(id);
        return RedirectToAction(nameof(Index));
    }
}