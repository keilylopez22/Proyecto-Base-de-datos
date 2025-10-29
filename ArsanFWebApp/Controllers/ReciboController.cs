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

        public async Task<IActionResult> Index(int PageIndex = 1, int PageSize = 10, DateTime? FechaEmisionFilter = null, int? IdPagoFilter = null,
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
        public async Task<IActionResult> ObtenerCobrosYPendientes(int numeroVivienda, int idCluster)
        {
            var cobros = await _reciboService.ObtenerCobrosPendientesAsync(numeroVivienda, idCluster);
            var multas = await _reciboService.ObtenerMultasPendientesAsync(numeroVivienda, idCluster);

            var resultado = cobros.Cast<dynamic>()
                .Concat(multas.Cast<dynamic>())
                .ToList();

            return Json(resultado);
        }

        [HttpGet]
        public async Task<IActionResult> Create(int? idPago = null)
        {
            if (idPago.HasValue)
            {
                // Precargar el IdPago en el modelo
                var recibo = new Recibo { IdPago = idPago.Value };
                ViewBag.Clusters = await _clusterService.ListarAsync();
                return View(recibo);
            }
            else
            {
                // O redirigir, o mostrar error, o dejar el campo editable
                ViewBag.Clusters = await _clusterService.ListarAsync();
                return View(new Recibo());
            }
            /*var clusters = await _clusterService.ListarAsync();
            ViewBag.Clusters = clusters.Select(c => new { c.IdCluster, c.Descripcion }).ToList();
            return View();*/
        }

        [HttpPost]
        public async Task<IActionResult> Create(Recibo model)
        {
            Console.WriteLine("Model received in Create POST:");
            Console.WriteLine($"IdPago: {model.IdPago}, FechaEmision: {model.FechaEmision}, NumeroVivienda: {model.NumeroVivienda}, IdCluster: {model.IdCluster}");

            if (!ModelState.IsValid)
            {
                foreach (var key in ModelState.Keys)
                {
                    var errors = ModelState[key].Errors;
                    if (errors.Count > 0)
                    {
                        Console.WriteLine($"Error en {key}: {errors[0].ErrorMessage}");
                    }
                }
            }
            if (ModelState.IsValid)
            {
                Console.WriteLine("ModelState is valid. Proceeding to insert.");
                // 1. Crear el recibo
                var idRecibo = await _reciboService.InsertarAsync(model);

                // 2. Crear los detalles seleccionados
                if (model.Detalles != null)
                {
                    foreach (var detalle in model.Detalles.Where(d =>
                        d.IdCobroServicio.HasValue || d.IdMultaVivienda.HasValue))
                    {
                        await _detalleService.InsertarAsync(new DetalleRecibo
                        {
                            IdRecibo = idRecibo,
                            IdCobroServicio = detalle.IdCobroServicio,
                            IdMultaVivienda = detalle.IdMultaVivienda
                        });
                    }
                }

                return RedirectToAction("Index");
            }
            ViewBag.Clusters = await _clusterService.ListarAsync();
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
