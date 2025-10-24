using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Services;
using ArsanWebApp.Models;

namespace ArsanWebApp.Controllers
{
    public class AsignacionTurnoController : Controller
    {
        private readonly AsignacionTurnoService _service;
        private const int TamanioPagina = 10;

        public AsignacionTurnoController(AsignacionTurnoService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index(int pagina = 1, int? idEmpleado = null, int? idTurno = null, DateTime? fechaAsignacion = null)
        {
            var (lista, total) = await _service.ObtenerTodosAsync(
                pagina,
                TamanioPagina,
                idEmpleado,
                idTurno,
                fechaAsignacion
            );

            int totalPaginas = (int)Math.Ceiling(total / (double)TamanioPagina);

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = totalPaginas;
            ViewBag.IdEmpleado = idEmpleado;
            ViewBag.IdTurno = idTurno;
            ViewBag.FechaAsignacion = fechaAsignacion;

            return View(lista);
        }

        public IActionResult Crear() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(AsignacionTurno asignacion)
        {
            if (!ModelState.IsValid) return View(asignacion);

            await _service.CrearAsync(asignacion);
            TempData["Success"] = "Asignación creada correctamente.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Editar(int id)
        {
            var asignacion = await _service.BuscarPorIdAsync(id);
            if (asignacion == null) return NotFound();
            return View(asignacion);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(AsignacionTurno asignacion)
        {
            if (!ModelState.IsValid) return View(asignacion);

            await _service.ActualizarAsync(asignacion);
            TempData["Success"] = "Asignación actualizada correctamente.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Eliminar(int id)
        {
            var asignacion = await _service.BuscarPorIdAsync(id);
            if (asignacion == null) return NotFound();
            return View(asignacion);
        }

        [HttpPost, ActionName("ConfirmarEliminar")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            await _service.EliminarAsync(id);
            TempData["Success"] = "Asignación eliminada correctamente.";
            return RedirectToAction(nameof(Index));
        }
    }
}
