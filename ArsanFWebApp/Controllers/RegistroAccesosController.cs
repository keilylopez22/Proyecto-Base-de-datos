using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using ArsanWebApp.Models;
using ArsanWebApp.Services;
using Microsoft.Extensions.Logging;

namespace ArsanWebApp.Controllers;

public class RegistroAccesosController : Controller
{
    private readonly RegistroAccesosService _service;
    private readonly ILogger<RegistroAccesosController> _logger;

    public RegistroAccesosController(RegistroAccesosService service, ILogger<RegistroAccesosController> logger)
    {
        _service = service;
        _logger = logger;
    }

    // GET: Listar todos con paginación
    public async Task<IActionResult> Index(int pagina = 1, int tamanoPagina = 10,
        DateTime? fechaIngresoDesde = null, DateTime? fechaIngresoHasta = null,
        int? idGaritaFilter = null, int? idEmpleadoFilter = null,
        string? tipoAccesoFilter = null)
    {
        var (registros, totalCount) = await _service.ObtenerTodosPaginadoAsync(
            pagina, tamanoPagina, fechaIngresoDesde, fechaIngresoHasta,
            idGaritaFilter, idEmpleadoFilter, tipoAccesoFilter);

        var totalPaginas = (int)Math.Ceiling(totalCount / (double)tamanoPagina);

        ViewBag.PaginaActual = pagina;
        ViewBag.TamanoPagina = tamanoPagina;
        ViewBag.TotalRegistros = totalCount;
        ViewBag.TotalPaginas = totalPaginas;
        ViewBag.FechaIngresoDesde = fechaIngresoDesde;
        ViewBag.FechaIngresoHasta = fechaIngresoHasta;
        ViewBag.IdGaritaFilter = idGaritaFilter;
        ViewBag.IdEmpleadoFilter = idEmpleadoFilter;
        ViewBag.TipoAccesoFilter = tipoAccesoFilter;
        

        await CargarFiltrosAsync();
        return View(registros);
    }

    // GET: Formulario crear
    public async Task<IActionResult> Create()
    {
        await CargarDropdownsAsync();
        return View();
    }

    // POST: Crear nuevo
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(RegistroAcceso registro)
    {
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
    public async Task<IActionResult> Edit(int id, RegistroAcceso registro)
    {
        if (id != registro.IdAcceso) return BadRequest();

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

    // GET: Detalles
    public async Task<IActionResult> Details(int id)
    {
        var registro = await _service.BuscarPorIdAsync(id);
        if (registro == null) return NotFound();
        return View(registro);
    }

    // Métodos privados
    private async Task CargarFiltrosAsync()
    {
        try
        {
            var garitas = await _service.ObtenerGaritasAsync();
            var empleados = await _service.ObtenerEmpleadosAsync();

            ViewBag.Garitas = new SelectList(garitas, "IdGarita", "Descripcion");
            ViewBag.Empleados = new SelectList(empleados, "IdEmpleado", "NombreCompleto");

            var tiposAcceso = new List<SelectListItem>
            {
                new() { Value = "Vehiculo", Text = "Vehículo" },
                new() { Value = "Visitante", Text = "Visitante" },
                new() { Value = "Residente", Text = "Residente" },
                new() { Value = "Empleado", Text = "Empleado" }
            };
            ViewBag.TiposAcceso = new SelectList(tiposAcceso, "Value", "Text");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al cargar filtros");
            ViewBag.Garitas = new SelectList(new List<SelectListItem>());
            ViewBag.Empleados = new SelectList(new List<SelectListItem>());
            ViewBag.TiposAcceso = new SelectList(new List<SelectListItem>());
        }
    }

    private async Task CargarDropdownsAsync()
    {
        try
        {
            ViewBag.Garitas = new SelectList(await _service.ObtenerGaritasAsync(), "IdGarita", "Descripcion");
            ViewBag.Empleados = new SelectList(await _service.ObtenerEmpleadosAsync(), "IdEmpleado", "NombreCompleto");
            ViewBag.Vehiculos = new SelectList(await _service.ObtenerVehiculosAsync(), "Value", "Text");
            ViewBag.Visitantes = new SelectList(await _service.ObtenerVisitantesAsync(), "Value", "Text");
            ViewBag.Residentes = new SelectList(await _service.ObtenerResidentesAsync(), "Value", "Text");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al cargar dropdowns");
            // Inicializar como listas vacías
            ViewBag.Garitas = new SelectList(new List<SelectListItem>());
            ViewBag.Empleados = new SelectList(new List<SelectListItem>());
            ViewBag.Vehiculos = new SelectList(new List<SelectListItem>());
            ViewBag.Visitantes = new SelectList(new List<SelectListItem>());
            ViewBag.Residentes = new SelectList(new List<SelectListItem>());
        }
    }
}