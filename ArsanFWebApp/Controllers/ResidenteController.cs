using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Services;
using ArsanWebApp.Models;

namespace ArsanWebApp.Controllers
{
    public class ResidenteController : Controller
    {
        private readonly ResidenteService _service;

        public ResidenteController(ResidenteService service)
        {
            _service = service;
        }

        public async Task<IActionResult> Index()
        {
            var residentes = await _service.ObtenerResidentesAsync();
            return View(residentes);
        }
    }
}