using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class VehiculoProhibidoController : Controller
    {
        private readonly VehiculoProhibidoService _service;
        private const int TamanioPagina = 10;

        public VehiculoProhibidoController(VehiculoProhibidoService service)
        {
            _service = service;
        }

        // INDEX con búsqueda por IdVehiculoProhibido, Fecha y paginación
        public async Task<IActionResult> Index(int pagina = 1, int? idProhibido = null, DateOnly? fecha = null)
        {
            var lista = await _service.ObtenerTodosAsync();

            // Filtrado por IdVehiculoProhibido
            if (idProhibido.HasValue)
                lista = lista.Where(x => x.IdVehiculoProhibido == idProhibido.Value).ToList();

            // Filtrado por Fecha
            if (fecha.HasValue)
                lista = lista.Where(x => x.Fecha.HasValue && x.Fecha.Value == fecha.Value).ToList();

            // Paginación
            int totalPaginas = (int)Math.Ceiling(lista.Count / (double)TamanioPagina);
            var listaPagina = lista.Skip((pagina - 1) * TamanioPagina).Take(TamanioPagina).ToList();

            // Pasar información a la vista
            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = totalPaginas;
            ViewBag.IdVehiculoProhibido = idProhibido;
            ViewBag.FechaBusqueda = fecha;

            return View(listaPagina);
        }

        // GET Crear
        public IActionResult Crear() => View();

        // POST Crear
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Crear(VehiculoProhibido vehiculo)
        {
            if (!ModelState.IsValid)
                return View(vehiculo);

            try
            {
                await _service.CrearAsync(vehiculo);
                TempData["Success"] = "Vehículo prohibido creado correctamente.";
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
                return View(vehiculo);
            }

            return RedirectToAction(nameof(Index));
        }

        // GET Editar
        public async Task<IActionResult> Editar(int id)
        {
            var vehiculo = await _service.BuscarPorIdAsync(id);
            if (vehiculo == null) return NotFound();
            return View(vehiculo);
        }

        // POST Editar
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
            }
            catch (Exception ex)
            {
                TempData["Error"] = ex.Message;
                return View(vehiculo);
            }

            return RedirectToAction(nameof(Index));
        }

        // GET Eliminar
        public async Task<IActionResult> Eliminar(int id)
        {
            var vehiculo = await _service.BuscarPorIdAsync(id);
            if (vehiculo == null) return NotFound();
            return View(vehiculo);
        }

        // POST Eliminar
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
    }
}
