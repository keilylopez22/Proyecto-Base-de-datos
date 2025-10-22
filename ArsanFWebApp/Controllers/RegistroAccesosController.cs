using Microsoft.AspNetCore.Mvc;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class RegistroAccesosController : Controller
{
    private readonly RegistroAccesosService _service;

    public RegistroAccesosController(RegistroAccesosService service)
    {
        _service = service;
    }

    // GET: Listar todos
    public async Task<IActionResult> Index()
    {
        var registros = await _service.ObtenerTodosAsync();
        return View(registros);
    }

    // GET: Formulario crear
    public async Task<IActionResult> Create()
    {
        await CargarDropdownsAsync();
        // Establecer fecha y hora actual por defecto
        var modelo = new RegistroAccesos 
        { 
            FechaIngreso = DateTime.Now
        };
        return View(modelo);
    }

    // POST: Crear nuevo
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(RegistroAccesos registro)
    {
        // Validación adicional: al menos uno debe estar presente
        if (registro.IdVehiculo == null && registro.IdVisitante == null && registro.IdResidente == null)
        {
            ModelState.AddModelError("", "Debe especificar al menos un Vehículo, Visitante o Residente.");
        }

        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(registro);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        await CargarDropdownsAsync();
        return View(registro);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var registro = await _service.BuscarPorIdAsync(id);
        if (registro == null) return NotFound();
        
        await CargarDropdownsAsync();
        return View(registro);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, RegistroAccesos registro)
    {
        if (id != registro.IdAcceso) return BadRequest();
        
        // Validación adicional
        if (registro.IdVehiculo == null && registro.IdVisitante == null && registro.IdResidente == null)
        {
            ModelState.AddModelError("", "Debe especificar al menos un Vehículo, Visitante o Residente.");
        }

        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(registro);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        await CargarDropdownsAsync();
        return View(registro);
    }

    // POST: Eliminar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Delete(int id)
    {
        var (exito, mensaje) = await _service.EliminarAsync(id);
        TempData[exito ? "Success" : "Error"] = mensaje;
        return RedirectToAction(nameof(Index));
    }

    // GET: Buscar por vehículo
    public async Task<IActionResult> SearchByVehicle(int idVehiculo)
    {
        var registros = await _service.BuscarPorVehiculoAsync(idVehiculo);
        ViewBag.SearchType = "Vehículo";
        return View("Index", registros);
    }

    // GET: Buscar por fecha
    public async Task<IActionResult> SearchByDate(DateTime fecha)
    {
        if (fecha == DateTime.MinValue)
            fecha = DateTime.Today;

        var registros = await _service.BuscarPorFechaIngresoAsync(fecha);
        ViewBag.SearchType = $"Fecha: {fecha:dd/MM/yyyy}";
        ViewBag.SearchDate = fecha;
        return View("Index", registros);
    }

    // GET: Detalles
    public async Task<IActionResult> Details(int id)
    {
        var registro = await _service.BuscarPorIdAsync(id);
        if (registro == null) return NotFound();
        return View(registro);
    }

    // Método privado para cargar dropdowns
    private async Task CargarDropdownsAsync()
    {
        ViewBag.Vehiculos = await _service.ObtenerVehiculosAsync();
        ViewBag.Visitantes = await _service.ObtenerVisitantesAsync();
        ViewBag.Residentes = await _service.ObtenerResidentesAsync();
        ViewBag.Garitas = await _service.ObtenerGaritasAsync();
        ViewBag.Empleados = await _service.ObtenerEmpleadosAsync();
    }
}