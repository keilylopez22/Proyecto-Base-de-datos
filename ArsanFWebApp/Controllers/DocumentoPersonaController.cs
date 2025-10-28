using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class DocumentoPersonaController : Controller
    {
        private readonly DocumentoPersonaService _service;
        private const int RegistrosPorPagina = 10;

        public DocumentoPersonaController(DocumentoPersonaService service)
        {
            _service = service;
        }
        public async Task<IActionResult> Index(int pagina = 1, int? numeroDocumento = null, int? idTipoDocumento = null)
        {
            var (lista, total) = await _service.ObtenerYContarAsync(
                pagina, RegistrosPorPagina, numeroDocumento, idTipoDocumento);

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling(total / (double)RegistrosPorPagina);
            ViewBag.BusquedaNumero = numeroDocumento;
            ViewBag.BusquedaTipo = idTipoDocumento;

            return View(lista);
        }


        public IActionResult Create() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DocumentoPersona doc)
        {
            if (!ModelState.IsValid) return View(doc);

            var error = await _service.CrearAsync(doc);
            if (error != null)
            {
                TempData["Error"] = error;
                return View(doc);
            }

            TempData["Mensaje"] = "Documento creado correctamente.";
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Edit(int idTipoDocumento, int idPersona)
        {
            var doc = await _service.BuscarPorIdAsync(idTipoDocumento, idPersona);
            if (doc == null) return NotFound();
            return View(doc);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(DocumentoPersona doc)
        {
            if (!ModelState.IsValid) return View(doc);
            
            var error = await _service.ActualizarAsync(doc);
            if (error != null)
            {
                TempData["Error"] = error;
                return View(doc);
            }

            TempData["Mensaje"] = "Documento actualizado correctamente.";
            return RedirectToAction(nameof(Index));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int idTipoDocumento, int idPersona)
        {
            var error = await _service.EliminarAsync(idTipoDocumento, idPersona);
            TempData["Mensaje"] = error == null ? "Documento eliminado correctamente." : null;
            TempData["Error"] = error;
            return RedirectToAction(nameof(Index));
        }

        public IActionResult BuscarPorNumero() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult BuscarPorNumero(int numeroDocumento)
        {
            return RedirectToAction(nameof(Index), new { pagina = 1, numeroDocumento = numeroDocumento, idTipoDocumento = (int?)null });
        }
    }
}