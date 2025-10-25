using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace ArsanWebApp.Controllers
{
    public class PuestoEmpleadoController : Controller
    {
        private readonly PuestoEmpleadoService _service;

        public PuestoEmpleadoController(PuestoEmpleadoService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index()
        {
            var puestos = await _service.ListarTodosAsync();
            return View(puestos);
        }

        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(PuestoEmpleado puesto)
        {
            if (ModelState.IsValid)
            {
                var (success, error) = await _service.InsertarAsync(puesto);
                if (success)
                    return RedirectToAction(nameof(Index));
                
                ModelState.AddModelError(string.Empty, error);
            }
            return View(puesto);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var puesto = await _service.ObtenerPorIdAsync(id);
            if (puesto == null)
                return NotFound();
            return View(puesto);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, PuestoEmpleado puesto)
        {
            if (id != puesto.IdPuestoEmpleado)
                return BadRequest();

            if (ModelState.IsValid)
            {
                var (success, error) = await _service.ActualizarAsync(puesto);
                if (success)
                    return RedirectToAction(nameof(Index));

                ModelState.AddModelError(string.Empty, error);
            }
            return View(puesto);
        }

        public async Task<IActionResult> Delete(int id)
        {
            var (success, error) = await _service.EliminarAsync(id);
            if (!success)
                TempData["Error"] = error;

            return RedirectToAction(nameof(Index));
        }
    }
}
