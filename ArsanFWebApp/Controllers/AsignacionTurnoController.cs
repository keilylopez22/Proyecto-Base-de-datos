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

        // INDEX con búsqueda y paginación
        public async Task<IActionResult> Index(int pagina = 1, int? idEmpleado = null, int? idTurno = null, DateTime? fechaAsignacion = null)
        {
            var lista = await _service.ObtenerTodosAsync();

            if (idEmpleado.HasValue)
                lista = lista.Where(x => x.IdEmpleado == idEmpleado.Value).ToList();

            if (idTurno.HasValue)
                lista = lista.Where(x => x.IdTurno == idTurno.Value).ToList();

            if (fechaAsignacion.HasValue)
                lista = lista.Where(x => x.FechaAsignacion.Date == fechaAsignacion.Value.Date).ToList();

            int totalPaginas = (int)Math.Ceiling(lista.Count / (double)TamanioPagina);
            var listaPagina = lista.Skip((pagina - 1) * TamanioPagina).Take(TamanioPagina).ToList();

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = totalPaginas;
            ViewBag.IdEmpleado = idEmpleado;
            ViewBag.IdTurno = idTurno;
            ViewBag.FechaAsignacion = fechaAsignacion;

            return View(listaPagina);
        }

        // GET Crear
        public IActionResult Crear() => View();

        // POST Crear
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(AsignacionTurno asignacion)
        {
            if (!ModelState.IsValid)
                return View(asignacion);

            await _service.CrearAsync(asignacion);
            TempData["Success"] = "Asignación creada correctamente.";
            return RedirectToAction(nameof(Index));
        }

        // GET Editar
        public async Task<IActionResult> Editar(int id)
        {
            var asignacion = await _service.BuscarPorIdAsync(id);
            if (asignacion == null) return NotFound();
            return View(asignacion);
        }

        // POST Editar
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(AsignacionTurno asignacion)
        {
            if (!ModelState.IsValid)
                return View(asignacion);

            await _service.ActualizarAsync(asignacion);
            TempData["Success"] = "Asignación actualizada correctamente.";
            return RedirectToAction(nameof(Index));
        }

        // GET Eliminar
        public async Task<IActionResult> Eliminar(int id)
        {
            var asignacion = await _service.BuscarPorIdAsync(id);
            if (asignacion == null) return NotFound();
            return View(asignacion);
        }

        // POST Eliminar
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
