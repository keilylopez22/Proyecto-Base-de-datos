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
        public async Task<IActionResult> Index(string buscarNombre, int page = 1, int pageSize = 5)
        {
            // Llamamos al SP con paginación
            var (lista, totalCount) = await _service.ObtenerTodosAsync(page, pageSize, buscarNombre);

            var totalPages = (int)Math.Ceiling((double)totalCount / pageSize);

            ViewBag.Page = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.BuscarNombre = buscarNombre;

            return View(lista);
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
    }
}
