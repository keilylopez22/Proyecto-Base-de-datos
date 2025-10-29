using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class EmpleadoController : Controller
    {
        private readonly EmpleadoService _service;

        public EmpleadoController(EmpleadoService service)
        {
            _service = service;
        }

        // Index con paginación y filtros (Ya estaba asíncrono)
        public async Task<IActionResult> Index(int? idEmpleado = null, string primerNombre = "", string primerApellido = "", int? idPuesto = null, int pagina = 1)
        {
            const int pageSize = 10;
            var (empleados, total) = await _service.ObtenerFiltradoPaginadoAsync(primerNombre, primerApellido, idPuesto, idEmpleado, pagina, pageSize);

            ViewBag.Pagina = pagina;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalPages = (int)Math.Ceiling(total / (double)pageSize);
            ViewBag.PrimerNombre = primerNombre;
            ViewBag.PrimerApellido = primerApellido;
            ViewBag.IdPuesto = idPuesto;
            ViewBag.IdEmpleado = idEmpleado;

            return View(empleados);
        }

        // Crear (GET)
        public IActionResult Crear() => View();

        [HttpPost]
        public async Task<IActionResult> Crear(Empleado empleado) // Usando async
        {
            if (!ModelState.IsValid) return View(empleado);
            
            await _service.InsertarAsync(empleado); // Llamando al método asíncrono
            
            return RedirectToAction(nameof(Index));
        }

        // Editar (GET)
        public async Task<IActionResult> Editar(int id) // Usando async
        {
            var empleado = await _service.BuscarPorIdAsync(id); // Llamando al método asíncrono
            
            if (empleado == null) return NotFound();
            return View(empleado);
        }

        [HttpPost]
        public async Task<IActionResult> Editar(Empleado empleado) // Usando async
        {
            if (!ModelState.IsValid) return View(empleado);
            
            await _service.ActualizarAsync(empleado); // Llamando al método asíncrono
            
            return RedirectToAction(nameof(Index));
        }

        // Eliminar (GET)
        public async Task<IActionResult> Eliminar(int id) // Usando async
        {
            var empleado = await _service.BuscarPorIdAsync(id); // Llamando al método asíncrono
            
            if (empleado == null) return NotFound();
            return View(empleado);
        }

        [HttpPost, ActionName("Eliminar")]
        public async Task<IActionResult> ConfirmarEliminar(int id) // Usando async
        {
            await _service.EliminarAsync(id); // Llamando al método asíncrono
            
            return RedirectToAction(nameof(Index));
        }
    }
}