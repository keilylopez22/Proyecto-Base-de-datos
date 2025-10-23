using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class TipoMultaController : Controller
    {
        private readonly TipoMultaService _service;

        public TipoMultaController(TipoMultaService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index()
        {
            var lista = await _service.ObtenerTodosAsync();
            return View(lista);
        }

       
        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(TipoMulta tipoMulta)
        {
            if (ModelState.IsValid)
            {
                await _service.InsertarAsync(tipoMulta);
                return RedirectToAction(nameof(Index));
            }
            return View(tipoMulta);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var tipoMulta = await _service.BuscarPorIdAsync(id);
            if (tipoMulta == null) return NotFound();
            return View(tipoMulta);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, TipoMulta tipoMulta)
        {
            if (id != tipoMulta.IdTipoMulta) return BadRequest();
            if (ModelState.IsValid)
            {
                await _service.ActualizarAsync(tipoMulta);
                return RedirectToAction(nameof(Index));
            }
            return View(tipoMulta);
        }

    
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.EliminarAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
