using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class MarcaController : Controller
{
    private readonly MarcaService _service;

    public MarcaController(MarcaService service)
    {
        _service = service;
    }

    // GET: Listar todas
    public async Task<IActionResult> Index()
    {
        var marcas = await _service.ObtenerTodasAsync();
        return View(marcas);
    }

    // GET: Formulario crear
    public IActionResult Create()
    {
        return View();
    }

    // POST: Crear nueva
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Marca marca)
    {
        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(marca);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        return View(marca);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var marca = await _service.BuscarPorIdAsync(id);
        if (marca == null) return NotFound();
        return View(marca);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Marca marca)
    {
        if (id != marca.IdMarca) return BadRequest();
        
        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(marca);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        return View(marca);
    }

    // POST: Eliminar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (exito, mensaje) = await _service.EliminarAsync(id);
        TempData[exito ? "Success" : "Error"] = mensaje;
        return RedirectToAction(nameof(Index));
    }

    // GET: Buscar por descripción
    public async Task<IActionResult> Search(string descripcion)
    {
        if (string.IsNullOrEmpty(descripcion))
            return RedirectToAction(nameof(Index));

        var marcas = await _service.BuscarPorDescripcionAsync(descripcion);
        ViewBag.SearchTerm = descripcion;
        return View("Index", marcas);
    }
}