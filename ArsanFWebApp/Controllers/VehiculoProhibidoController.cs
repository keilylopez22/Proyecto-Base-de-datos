using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class VehiculoProhibidoController : Controller
    {
        private readonly VehiculoProhibidoService _service;
        private const int TamanioPagina = 5;

        public VehiculoProhibidoController(VehiculoProhibidoService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index(int pagina = 1, string? placa = null, string? motivo = null, DateTime? fecha = null)
        {
            var (lista, totalRegistros) = await _service.ObtenerTodosAsync(pagina, TamanioPagina, placa, motivo, fecha);

            int totalPaginas = (int)Math.Ceiling(totalRegistros / (double)TamanioPagina);

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = totalPaginas;

            ViewBag.Motivo = motivo;
            ViewBag.Fecha = fecha;

            return View(lista);
        }

        public async Task<IActionResult> Editar(int id)
        {
            var vehiculo = await _service.BuscarPorIdAsync(id);
            if (vehiculo == null)
                return NotFound();

            return View(vehiculo);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(VehiculoProhibido vehiculo)
        {
            if (!ModelState.IsValid)
                return View(vehiculo);

            try
            {
                await _service.ActualizarAsync(vehiculo);
                TempData["Success"] = "Vehículo prohibido actualizado correctamente.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
                return View(vehiculo);
            }
        }

        public async Task<IActionResult> Eliminar(int id)
        {
            var vehiculo = await _service.BuscarPorIdAsync(id);
            if (vehiculo == null)
                return NotFound();

            return View(vehiculo);
        }

        [HttpPost, ActionName("Eliminar")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmarEliminar(int id)
        {
            try
            {
                await _service.EliminarAsync(id);
                TempData["Success"] = "Vehículo prohibido eliminado correctamente.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
            }

            return RedirectToAction(nameof(Index));
        }

        public IActionResult Crear() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(VehiculoProhibido vehiculo)
        {
            if (!ModelState.IsValid)
                return View(vehiculo);

            try
            {
                await _service.CrearAsync(vehiculo);
                TempData["Success"] = "Vehículo prohibido agregado correctamente.";
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
                return View(vehiculo);
            }
        }
    }
}
