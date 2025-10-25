using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Services;
using ArsanWebApp.Models;

namespace ArsanWebApp.Controllers
{
    public class DetalleReciboController : Controller
    {
        private readonly DetalleReciboService _detalleReciboService;

        public DetalleReciboController(DetalleReciboService detalleReciboService)
        {
            _detalleReciboService = detalleReciboService;
        }

        // 🔹 Vista principal que muestra los detalles filtrados por IdRecibo
        public IActionResult Index(int? idRecibo)
        {
            if (idRecibo == null)
                return View(new List<DetalleRecibo>());

            var detalles = _detalleReciboService.BuscarPorIdRecibo(idRecibo.Value);
            ViewBag.IdRecibo = idRecibo;
            return View(detalles);
        }

        // 🔹 Acción del botón “Ver Detalles”
        public IActionResult VerDetalles(int idRecibo)
        {
            var detalles = _detalleReciboService.BuscarPorIdRecibo(idRecibo);
            ViewBag.IdRecibo = idRecibo;
            return View("Index", detalles);
        }
    }
}
