using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class PuestoEmpleadoController : Controller
    {
        private readonly PuestoEmpleadoService _service;

        public PuestoEmpleadoController(PuestoEmpleadoService service)
        {
            _service = service;
        }

        // GET: Index con búsqueda y paginación
        public async Task<IActionResult> Index(int? buscarId, string buscarNombre, int page = 1, int pageSize = 5)
        {
            // Obtener todos los puestos
            var puestos = await _service.ObtenerTodosAsync();

            // Filtrar por Id si se pasa
            if (buscarId.HasValue)
            {
                puestos = puestos.Where(p => p.IdPuestoEmpleado == buscarId.Value).ToList();
            }

            // Filtrar por Nombre si se pasa
            if (!string.IsNullOrEmpty(buscarNombre))
            {
                puestos = puestos
                    .Where(p => !string.IsNullOrEmpty(p.Nombre) && p.Nombre.Contains(buscarNombre, StringComparison.OrdinalIgnoreCase))
                    .ToList();
            }

            // Paginación
            int totalItems = puestos.Count;
            var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            var paged = puestos.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            ViewBag.Page = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.BuscarId = buscarId;
            ViewBag.BuscarNombre = buscarNombre;

            return View(paged);
        }

        // GET: Create
        public IActionResult Create() => View();

        // POST: Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(PuestoEmpleado puesto)
        {
            if (!ModelState.IsValid) return View(puesto);

            await _service.CrearAsync(puesto);
            return RedirectToAction(nameof(Index));
        }

        // GET: Edit
        public async Task<IActionResult> Edit(int id)
        {
            var puesto = await _service.BuscarPorIdAsync(id);
            if (puesto == null) return NotFound();
            return View(puesto);
        }

        // POST: Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(PuestoEmpleado puesto)
        {
            if (!ModelState.IsValid) return View(puesto);

            await _service.ActualizarAsync(puesto);
            return RedirectToAction(nameof(Index));
        }

        // GET: Delete
        public async Task<IActionResult> Delete(int id)
        {
            var puesto = await _service.BuscarPorIdAsync(id);
            if (puesto == null) return NotFound();
            return View(puesto);
        }

        // POST: Delete
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConfirmDelete(int id)
        {
            await _service.EliminarAsync(id);
            return RedirectToAction(nameof(Index));
        }

        // GET: Buscar por Id
        public async Task<IActionResult> BuscarPorId(int id)
        {
            var puesto = await _service.BuscarPorIdAsync(id);
            if (puesto == null) return NotFound();
            return View(puesto);
        }
    }
}
