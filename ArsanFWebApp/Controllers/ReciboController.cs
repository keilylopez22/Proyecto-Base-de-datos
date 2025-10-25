using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;
using System.Threading.Tasks;

namespace ArsanWebApp.Controllers
{
    public class ReciboController : Controller
    {
        private readonly ReciboService _reciboService;
        private readonly DetalleReciboService _detalleService;
        private readonly ClusterService _clusterService;

        public ReciboController(ReciboService reciboService, DetalleReciboService detalleService, ClusterService clusterService)
        {
            _reciboService = reciboService;
            _detalleService = detalleService;
            _clusterService = clusterService;
        }

        public async Task < IActionResult> Index(int PageIndex = 1, int PageSize = 10 , DateTime? FechaEmisionFilter = null, int? IdPagoFilter= null,
            int? NumeroViviendaFilter = null, int? ClusterFilter = null)
        {

            var (lista, TotalCount) = await _reciboService.ObtenerTodos(
                PageIndex,
                PageSize,
                FechaEmisionFilter,
                IdPagoFilter,
                NumeroViviendaFilter,
                ClusterFilter
            );
            var paginatedList = new PaginatedList<Recibo>(lista, TotalCount, PageIndex, PageSize);
            ViewBag.FechaEmisionFilter = FechaEmisionFilter;
            ViewBag.IdPagoFilter = IdPagoFilter;
            ViewBag.NumeroViviendaFilter = NumeroViviendaFilter;
            ViewBag.ClusterFilter = ClusterFilter;
            ViewBag.PageIndex = PageIndex;
            ViewBag.PageSize = PageSize;

            return View(paginatedList);
        }

        public IActionResult Details(int id)
        {
            var recibo = _reciboService.ObtenerPorId(id);

            if (recibo == null)
                return NotFound();

            recibo.Detalles = _detalleService.BuscarPorIdRecibo(id);

            return View(recibo);
        }

        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var clusters = await _clusterService.ListarAsync(); 
            ViewBag.Clusters = clusters.Select(c => new { c.IdCluster, c.Descripcion }).ToList();
            return View();
        }

        [HttpPost]
        public IActionResult Create(Recibo model)
        {
            if (ModelState.IsValid)
            {
                _reciboService.Insertar(model);
                return RedirectToAction("Index");
            }
            return View(model);
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            var recibo = _reciboService.ObtenerPorId(id);
            if (recibo == null)
                return NotFound();
            return View(recibo);
        }

        [HttpPost]
        public IActionResult Edit(Recibo model)
        {
            if (ModelState.IsValid)
            {
                _reciboService.Actualizar(model);
                return RedirectToAction("Index");
            }
            return View(model);
        }
        [HttpGet]
        public IActionResult ObtenerPropietario(int numeroVivienda, int idCluster)
        {
              var nombrePropietario = _reciboService.ObtenerPropietario(numeroVivienda, idCluster);
              return Json(new { nombreCompleto = nombrePropietario ?? "" });
        }

    }
}
