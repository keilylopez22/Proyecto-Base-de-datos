using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers
{
    public class ServicioController : Controller
    {
        private readonly ServicioService _servicioService;

        public ServicioController(ServicioService servicioService)
        {
            _servicioService = servicioService;
        }

        public async Task<IActionResult> Index()
        {
            var lista = await _servicioService.ObtenerTodosAsync();
            return View(lista);
        }


        public IActionResult Create()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(Servicio servicio)
        {
            if (ModelState.IsValid)
            {
                await _servicioService.InsertarAsync(servicio);
                return RedirectToAction(nameof(Index));
            }
            return View(servicio);
        }

        public async Task<IActionResult> Edit(int id)
        {
            var servicio = await _servicioService.BuscarPorIdAsync(id);
            if (servicio == null)
                return NotFound();

            return View(servicio);
        }

 
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, Servicio servicio)
        {
            if (id != servicio.IdServicio)
                return BadRequest();

            if (ModelState.IsValid)
            {
                await _servicioService.ActualizarAsync(servicio);
                return RedirectToAction(nameof(Index));
            }

            return View(servicio);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            await _servicioService.EliminarAsync(id);
            return RedirectToAction(nameof(Index));
        }
    }
}
