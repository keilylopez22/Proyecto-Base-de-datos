using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class TipoPagoController : Controller
{
    private readonly TipoPagoService _tipoPagoService;

    public TipoPagoController(TipoPagoService tipoPagoService)
    {
        _tipoPagoService = tipoPagoService;
    }


    public async Task<IActionResult> Index()
    {
        var lista = await _tipoPagoService.ObtenerTodosAsync();
        return View(lista);
    }

 
    public IActionResult Create()
    {
        return View();
    }

    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(TipoPago tipoPago)
    {
        if (ModelState.IsValid)
        {
            await _tipoPagoService.InsertarAsync(tipoPago);
            return RedirectToAction(nameof(Index));
        }
        return View(tipoPago);
    }


    public async Task<IActionResult> Edit(int id)
    {
        var tipoPago = await _tipoPagoService.BuscarPorIdAsync(id);
        if (tipoPago == null) return NotFound();
        return View(tipoPago);
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, TipoPago tipoPago)
    {
        if (id != tipoPago.IdTipoPago) return BadRequest();
        if (ModelState.IsValid)
        {
            await _tipoPagoService.ActualizarAsync(tipoPago);
            return RedirectToAction(nameof(Index));
        }
        return View(tipoPago);
    }

   
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (exito, mensaje) = await _tipoPagoService.EliminarAsync(id);
        TempData["Error"] = exito ? null : mensaje;
        return RedirectToAction(nameof(Index));
    }
}
