using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class LineaController : Controller
{
    private readonly LineaService _service;

    public LineaController(LineaService service)
    {
        _service = service;
    }

    // GET: Listar todas
    public async Task<IActionResult> Index()
    {
        var lineas = await _service.ObtenerTodasAsync();
        return View(lineas);
    }

    // GET: Formulario crear
    public async Task<IActionResult> Create()
    {
        ViewBag.Marcas = await _service.ObtenerMarcasAsync();
        return View();
    }

    // POST: Crear nueva
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Linea linea)
    {
        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(linea);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        ViewBag.Marcas = await _service.ObtenerMarcasAsync();
        return View(linea);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var linea = await _service.BuscarPorIdAsync(id);
        if (linea == null) return NotFound();
        
        ViewBag.Marcas = await _service.ObtenerMarcasAsync();
        return View(linea);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Linea linea)
    {
        if (id != linea.IdLinea) return BadRequest();
        
        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(linea);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        ViewBag.Marcas = await _service.ObtenerMarcasAsync();
        return View(linea);
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

        var lineas = await _service.BuscarPorDescripcionAsync(descripcion);
        ViewBag.SearchTerm = descripcion;
        return View("Index", lineas);
    }
}