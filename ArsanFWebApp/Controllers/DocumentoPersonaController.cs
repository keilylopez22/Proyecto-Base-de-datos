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

        // Listar documentos
        public async Task<IActionResult> Index(int pagina = 1, int? numeroDocumento = null, int? idTipoDocumento = null)
        {
            var lista = await _service.ObtenerAsync(pagina, RegistrosPorPagina, numeroDocumento, idTipoDocumento);
            int total = await _service.ContarAsync(numeroDocumento, idTipoDocumento);

            ViewBag.PaginaActual = pagina;
            ViewBag.TotalPaginas = (int)Math.Ceiling(total / (double)RegistrosPorPagina);
            ViewBag.BusquedaNumero = numeroDocumento;
            ViewBag.BusquedaTipo = idTipoDocumento;

            return View(lista);
        }

        // Formulario crear
        public IActionResult Create() => View();

        // Crear documento
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(DocumentoPersona doc)
        {
            if (!ModelState.IsValid) return View(doc);

            // Validar duplicado antes de crear
            var lista = await _service.ObtenerAsync(1, int.MaxValue, doc.NumeroDocumento, doc.IdTipoDocumento);
            if (lista.Any(d => d.IdPersona == doc.IdPersona && d.IdTipoDocumento == doc.IdTipoDocumento && d.NumeroDocumento == doc.NumeroDocumento))
            {
                TempData["Error"] = "Ya existe un documento con este número para esta persona y tipo.";
                return View(doc);
            }

            var error = await _service.CrearAsync(doc);
            if (error != null)
            {
                TempData["Error"] = error;
                return View(doc);
            }

            TempData["Mensaje"] = "Documento creado correctamente.";
            return RedirectToAction(nameof(Index));
        }

        // Editar documento GET
        public async Task<IActionResult> Edit(int idTipoDocumento, int idPersona)
        {
            var doc = await _service.BuscarPorIdAsync(idTipoDocumento, idPersona);
            if (doc == null) return NotFound();
            return View(doc);
        }

        // Editar documento POST
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(DocumentoPersona doc)
        {
            if (!ModelState.IsValid) return View(doc);

            var lista = await _service.ObtenerAsync(1, int.MaxValue, doc.NumeroDocumento, doc.IdTipoDocumento);
            if (lista.Any(d => d.IdPersona != doc.IdPersona && d.IdTipoDocumento == doc.IdTipoDocumento && d.NumeroDocumento == doc.NumeroDocumento))
            {
                TempData["Error"] = "Ya existe un documento con ese número para este tipo.";
                return View(doc);
            }

            var error = await _service.ActualizarAsync(doc);
            if (error != null)
            {
                TempData["Error"] = error;
                return View(doc);
            }

            TempData["Mensaje"] = "Documento actualizado correctamente.";
            return RedirectToAction(nameof(Index));
        }

        // Eliminar documento
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int idTipoDocumento, int idPersona)
        {
            var error = await _service.EliminarAsync(idTipoDocumento, idPersona);
            TempData["Mensaje"] = error == null ? "Documento eliminado correctamente." : null;
            TempData["Error"] = error;
            return RedirectToAction(nameof(Index));
        }

        // Buscar por número
        public IActionResult BuscarPorNumero() => View();

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BuscarPorNumero(int numeroDocumento)
        {
            var lista = await _service.ObtenerAsync(1, int.MaxValue, numeroDocumento, null);
            return View("Index", lista);
        }
    }
}
