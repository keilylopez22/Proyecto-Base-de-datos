using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ArsanWebApp.Controllers
{
    public class PagoController : Controller
    {
        private readonly PagoService _pagoService;
        private readonly TipoPagoService _tipoPagoService;
        private readonly DetallePagoService _detallePagoService;


        public PagoController(PagoService pagoService, DetallePagoService detallePagoService, TipoPagoService tipoPagoService)
        {
            _pagoService = pagoService;
            _detallePagoService = detallePagoService;
            _tipoPagoService = tipoPagoService;
        }

        public IActionResult Index(DateTime? fechaPagoFilter, decimal? montoFilter, string nombreTipoPagoFilter, int pageIndex = 1, int pageSize = 10)
        {
            var (pagos, totalCount) = _pagoService.GetPagos(fechaPagoFilter, montoFilter, nombreTipoPagoFilter, pageIndex, pageSize);

            ViewData["Title"] = "Pagos";
            ViewData["TotalCount"] = totalCount;
            ViewData["PageIndex"] = pageIndex;
            ViewData["PageSize"] = pageSize;
            ViewData["FechaPagoFilter"] = fechaPagoFilter?.ToString("yyyy-MM-dd") ?? "";
            ViewData["MontoFilter"] = montoFilter;
            ViewData["NombreTipoPagoFilter"] = nombreTipoPagoFilter;

            return View(pagos);
        }


        // En PagoController.cs

        public async Task<IActionResult> Create()
        {
            ViewBag.TipoPagos = await _tipoPagoService.ObtenerTodosAsync(); // Asegúrate de tener este servicio
            return View(new Pago());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Pago pago)
        {
            Console.WriteLine("monto:"+ pago.MontoTotal);
            if (pago.Detalles == null || !pago.Detalles.Any())
            {
                ModelState.AddModelError("", "Debe agregar al menos un detalle de pago.");
            }

            if (ModelState.IsValid)
            {
                
                var idPago = _pagoService.CrearPago(pago); 

                
                foreach (var detalle in pago.Detalles)
                {
                    detalle.IdPago = idPago;
                    await _detallePagoService.InsertarAsync(detalle); 
                }

                return RedirectToAction(nameof(Index));
            }

            ViewBag.TipoPagos = await _tipoPagoService.ObtenerTodosAsync();
            return View(pago);
        }

        public IActionResult Edit(int id)
        {
            var pago = _pagoService.GetPagoById(id);
            if (pago == null) return NotFound();

            var tiposPago = _pagoService.GetAllTipoPago();
            //ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre", pago.IdTipoPago);

            return View(pago);
        }

        [HttpPost]
        public IActionResult Edit(Pago pago)
        {
            if (ModelState.IsValid)
            {
                _pagoService.ActualizarPago(pago);
                return RedirectToAction(nameof(Index));
            }

            var tiposPago = _pagoService.GetAllTipoPago();
            //ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre", pago.IdTipoPago);
            return View(pago);
        }

        public IActionResult Delete(int id)
        {
            _pagoService.EliminarPago(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
