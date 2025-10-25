using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace ArsanWebApp.Controllers
{
    public class AsignacionTurnoController : Controller
    {
        private readonly AsignacionTurnoService _service;

        public AsignacionTurnoController(AsignacionTurnoService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index()
        {
            var lista = await _service.ListarTodosAsync();
            return View(lista);
        }

        public IActionResult Create() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(AsignacionTurno asignacion)
        {
            if (ModelState.IsValid)
            {
                var (exito, mensaje) = await _service.CrearAsync(asignacion);
                if (exito) return RedirectToAction(nameof(Index));

                ModelState.AddModelError(string.Empty, mensaje);
            }
            return View(asignacion);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var asignacion = await _service.ObtenerPorIdAsync(id);
            if (asignacion == null) return NotFound();
            return View(asignacion);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, AsignacionTurno asignacion)
        {
            if (id != asignacion.IdAsignacionTurno) return BadRequest();

            if (ModelState.IsValid)
            {
                var (exito, mensaje) = await _service.ActualizarAsync(asignacion);
                if (exito) return RedirectToAction(nameof(Index));

                ModelState.AddModelError(string.Empty, mensaje);
            }
            return View(asignacion);
        }

        public async Task<IActionResult> Delete(int id)
        {
            var (exito, mensaje) = await _service.EliminarAsync(id);
            if (!exito) TempData["Error"] = mensaje;

            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> FiltrarPorFecha(DateTime fecha)
        {
            var lista = await _service.BuscarPorFechaAsync(fecha);
            return View("Index", lista);
        }

        public async Task<IActionResult> FiltrarPorEmpleado(int idEmpleado)
        {
            var lista = await _service.BuscarPorEmpleadoAsync(idEmpleado);
            return View("Index", lista);
        }
    }
}
