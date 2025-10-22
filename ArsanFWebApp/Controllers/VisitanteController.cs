using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class VisitanteController : Controller
{
    private readonly VisitanteService _service;

    public VisitanteController(VisitanteService service)
    {
        _service = service;
    }

    // GET: Listar todos
    public async Task<IActionResult> Index()
    {
        var visitantes = await _service.ObtenerTodosAsync();
        return View(visitantes);
    }

    // GET: Formulario crear
    public async Task<IActionResult> Create()
    {
        ViewBag.TiposDocumento = await _service.ObtenerTiposDocumentoAsync();
        return View();
    }

    // POST: Crear nuevo
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Visitante visitante)
    {
        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(visitante);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        ViewBag.TiposDocumento = await _service.ObtenerTiposDocumentoAsync();
        return View(visitante);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var visitante = await _service.BuscarPorIdAsync(id);
        if (visitante == null) return NotFound();
        
        ViewBag.TiposDocumento = await _service.ObtenerTiposDocumentoAsync();
        return View(visitante);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Visitante visitante)
    {
        if (id != visitante.IdVisitante) return BadRequest();
        
        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(visitante);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        ViewBag.TiposDocumento = await _service.ObtenerTiposDocumentoAsync();
        return View(visitante);
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

    // GET: Buscar por documento
    public async Task<IActionResult> Search(string numeroDocumento)
    {
        if (string.IsNullOrEmpty(numeroDocumento))
            return RedirectToAction(nameof(Index));

        var visitante = await _service.BuscarPorDocumentoAsync(numeroDocumento);
        if (visitante == null)
        {
            TempData["Error"] = "No se encontró ningún visitante con ese documento.";
            return RedirectToAction(nameof(Index));
        }
        
        return View("Details", visitante);
    }

    // GET: Detalles
    public async Task<IActionResult> Details(int id)
    {
        var visitante = await _service.BuscarPorIdAsync(id);
        if (visitante == null) return NotFound();
        return View(visitante);
    }
}