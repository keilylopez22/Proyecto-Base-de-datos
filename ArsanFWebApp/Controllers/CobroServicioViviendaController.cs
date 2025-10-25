using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ArsanWebApp.Controllers
{
    public class CobroServicioViviendaController : Controller
    {
        private readonly CobroServicioViviendaService _cobroService;
        private readonly ServicioService _servicioService;
        private readonly ViviendaService _viviendaService;

        public CobroServicioViviendaController(
            CobroServicioViviendaService cobroService,
            ServicioService servicioService,
            ViviendaService viviendaService)
        {
            _cobroService = cobroService;
            _servicioService = servicioService;
            _viviendaService = viviendaService;
        }

       public async Task<IActionResult> Index(
            int pageIndex = 1,
            int pageSize = 10,
            string? fechaFilter = null,
            string? servicioFilter = null,
            int? numeroViviendaFilter = null,
            int? clusterFilter = null)
        {
              DateTime? fecha = null;
            if (!string.IsNullOrEmpty(fechaFilter))
            {
                if (DateTime.TryParse(fechaFilter, out var fechaParse))
                {
                    fecha = fechaParse;
                }
            }
            
            var (lista, totalCount) = await _cobroService.ListarAsync(
                pageIndex, pageSize, fechaFilter ?? "", servicioFilter ?? "", numeroViviendaFilter, clusterFilter);

            var servicios = await _servicioService.ListarServicioAsync();
            var clusters = await _viviendaService.ObtenerClustersAsync();

            ViewBag.Servicios = servicios;
            ViewBag.Clusters = clusters;
            ViewBag.FechaFilter = fechaFilter ?? "";
            ViewBag.SelectedServicio = servicioFilter ?? "";
            ViewBag.SelectedCluster = clusterFilter ?? 0;

            ViewBag.TotalCount = totalCount;
            ViewBag.PageIndex = pageIndex;
            ViewBag.PageSize = pageSize;

            return View(lista);
        }
        public async Task<IActionResult> Create()
        {
            var clusters = await _viviendaService.ObtenerClustersAsync() ?? new List<Cluster>();
            var servicios = await _servicioService.ListarServicioAsync() ?? new List<Servicio>();

            ViewBag.Servicios = new SelectList(servicios, "IdServicio", "Nombre");
            ViewBag.Clusters = new SelectList(clusters, "IdCluster", "Descripcion");            
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CobroServicioVivienda modelo)
        {
            if (ModelState.IsValid)
            {
                await _cobroService.InsertarAsync(modelo);
                return RedirectToAction(nameof(Index));
            }
            var servicios = await _servicioService.ListarServicioAsync() ?? new List<Servicio>();
            var clusters = await _viviendaService.ObtenerClustersAsync() ?? new List<Cluster>();

            ViewBag.Servicios = new SelectList(servicios, "IdServicio", "Nombre", modelo.IdServicio);
            ViewBag.Clusters = new SelectList(clusters, "IdCluster", "Descripcion", modelo.IdCluster);

            return View(modelo);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var cobro = await _cobroService.ObtenerPorIdAsync(id);
            if (cobro == null) return NotFound();
            ViewBag.Servicios = new SelectList(await _servicioService.ListarServicioAsync(), "IdServicio", "Nombre", cobro.IdServicio);
            ViewBag.Clusters = new SelectList(await _viviendaService.ObtenerClustersAsync(), "IdCluster", "Descripcion", cobro.IdCluster);
            return View(cobro);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(CobroServicioVivienda modelo)
        {
            if (ModelState.IsValid)
            {
                await _cobroService.ActualizarAsync(modelo);
                return RedirectToAction(nameof(Index));
            }

            ViewBag.Servicios = new SelectList(await _servicioService.ListarServicioAsync(), "IdServicio", "Nombre", modelo.IdServicio);
            ViewBag.Clusters = new SelectList(await _viviendaService.ObtenerClustersAsync(), "IdCluster", "Descripcion", modelo.IdCluster);
            return View(modelo);
        }

        public async Task<IActionResult> Delete(int id)
        {
            var cobro = await _cobroService.ObtenerPorIdAsync(id);
            if (cobro == null) return NotFound();
            return View(cobro);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            await _cobroService.EliminarAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
