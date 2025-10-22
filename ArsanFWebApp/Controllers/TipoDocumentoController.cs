using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class TipoDocumentoController : Controller
{
    private readonly TipoDocumentoService _service;

    public TipoDocumentoController(TipoDocumentoService service)
    {
        _service = service;
    }

    // GET: Listar todos
    public async Task<IActionResult> Index()
    {
        var tipos = await _service.ObtenerTodosAsync();
        return View(tipos);
    }

    // GET: Formulario crear
    public IActionResult Create()
    {
        return View();
    }

    // POST: Crear nuevo
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(TipoDocumento tipoDocumento)
    {
        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(tipoDocumento);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        return View(tipoDocumento);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var tipo = await _service.BuscarPorIdAsync(id);
        if (tipo == null) return NotFound();
        return View(tipo);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, TipoDocumento tipoDocumento)
    {
        if (id != tipoDocumento.IdTipoDocumento) return BadRequest();
        
        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(tipoDocumento);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        return View(tipoDocumento);
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
}