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

        // Index con paginación y filtros
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

        // Crear
        public IActionResult Crear() => View();

        [HttpPost]
        public IActionResult Crear(Empleado empleado)
        {
            if (!ModelState.IsValid) return View(empleado);
            _service.Insertar(empleado);
            return RedirectToAction(nameof(Index));
        }

        // Editar
        public IActionResult Editar(int id)
        {
            var empleado = _service.BuscarPorId(id);
            if (empleado == null) return NotFound();
            return View(empleado);
        }

        [HttpPost]
        public IActionResult Editar(Empleado empleado)
        {
            if (!ModelState.IsValid) return View(empleado);
            _service.Actualizar(empleado);
            return RedirectToAction(nameof(Index));
        }

        // Eliminar
        public IActionResult Eliminar(int id)
        {
            var empleado = _service.BuscarPorId(id);
            if (empleado == null) return NotFound();
            return View(empleado);
        }

        [HttpPost, ActionName("Eliminar")]
        public IActionResult ConfirmarEliminar(int id)
        {
            _service.Eliminar(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
