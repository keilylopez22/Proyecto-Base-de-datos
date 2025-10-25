using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace ArsanWebApp.Controllers
{
    public class PagoController : Controller
    {
        private readonly PagoService _pagoService;
       

        public PagoController(PagoService pagoService)
        {
            _pagoService = pagoService;
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

      
        public IActionResult Create()
        {
            var tiposPago = _pagoService.GetAllTipoPago();
            ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre");
            return View();
        }

    
        [HttpPost]
        public IActionResult Create(Pago pago)
        {
            if (ModelState.IsValid)
            {
                _pagoService.CrearPago(pago);
                return RedirectToAction(nameof(Index));
            }

            var tiposPago = _pagoService.GetAllTipoPago();
            ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre", pago.IdTipoPago);
            return View(pago);
        }

        public IActionResult Edit(int id)
        {
            var pago = _pagoService.GetPagoById(id);
            if (pago == null) return NotFound();

            var tiposPago = _pagoService.GetAllTipoPago();
            ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre", pago.IdTipoPago);

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
            ViewBag.TiposPago = new SelectList(tiposPago, "IdTipoPago", "Nombre", pago.IdTipoPago);
            return View(pago);
        }

        public IActionResult Delete(int id)
        {
            _pagoService.EliminarPago(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
