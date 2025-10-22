using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using ArsanWebApp.Models;
using ArsanWebApp.Services;

namespace ArsanWebApp.Controllers;

public class VehiculoController : Controller
{
   private readonly VehiculoService _service;
    private readonly ILogger<VehiculoController> _logger;

    public VehiculoController(VehiculoService service, ILogger<VehiculoController> logger)
    {
        _service = service;
        _logger = logger;
    }

    // GET: Listar todos
    public async Task<IActionResult> Index()
    {
        var vehiculos = await _service.ObtenerTodosAsync();
        return View(vehiculos);
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
    public async Task<IActionResult> Create(Vehiculo vehiculo)
    {
        _logger.LogInformation("Create POST received: IdLinea={IdLinea}, IdMarca={IdMarca}, NumeroVivienda={NumeroVivienda}, IdCluster={IdCluster}, Placa={Placa}",
        vehiculo.IdLinea, vehiculo.IdMarca, vehiculo.NumeroVivienda, vehiculo.IdCluster, vehiculo.Placa);
        if (ModelState.IsValid)
        {
            var (exito, mensaje, id) = await _service.InsertarAsync(vehiculo);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        await CargarDropdownsAsync();
        return View(vehiculo);
    }

    // GET: Formulario editar
    public async Task<IActionResult> Edit(int id)
    {
        var vehiculo = await _service.BuscarPorIdAsync(id);
        if (vehiculo == null) return NotFound();
        
        await CargarDropdownsAsync();
        return View(vehiculo);
    }

    // POST: Editar
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Edit(int id, Vehiculo vehiculo)
    {
        if (id != vehiculo.IdVehiculo) return BadRequest();
        
        if (ModelState.IsValid)
        {
            var (exito, mensaje) = await _service.ActualizarAsync(vehiculo);
            if (exito)
            {
                TempData["Success"] = mensaje;
                return RedirectToAction(nameof(Index));
            }
            TempData["Error"] = mensaje;
        }
        await CargarDropdownsAsync();
        return View(vehiculo);
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

    // GET: Buscar por placa
    public async Task<IActionResult> Search(string placa)
    {
        if (string.IsNullOrEmpty(placa))
            return RedirectToAction(nameof(Index));

        var vehiculo = await _service.BuscarPorPlacaAsync(placa);
        if (vehiculo == null)
        {
            TempData["Error"] = "No se encontró ningún vehículo con esa placa.";
            return RedirectToAction(nameof(Index));
        }
        
        var vehiculos = new List<Vehiculo> { vehiculo };
        ViewBag.SearchTerm = placa;
        return View("Index", vehiculos);
    }

    // GET: Detalles
    public async Task<IActionResult> Details(int id)
    {
        var vehiculo = await _service.BuscarPorIdAsync(id);
        if (vehiculo == null) return NotFound();
        return View(vehiculo);
    }

    // Método privado para cargar dropdowns
    private async Task CargarDropdownsAsync()
{
    try
    {
        var lineas = await _service.ObtenerLineasAsync();
        var viviendas = await _service.ObtenerViviendasAsync();

        // Para líneas, necesitamos almacenar tanto IdLinea como IdMarca
        var lineaItems = (lineas ?? new List<Linea>())
            .Select(l => new 
            { 
                IdLinea = l.IdLinea, 
                IdMarca = l.IdMarca,
                Text = $"{l.Descripcion} - {l.Marca}"
            })
            .ToList();
        
        ViewBag.Lineas = new SelectList(lineaItems, "IdLinea", "Text");
        ViewBag.LineasConMarca = lineaItems; // Para usar en el JavaScript

        // Viviendas y Clusters (igual que antes)
        var viviendaItems = (viviendas ?? new List<Vivienda>())
            .Select(v => new SelectListItem
            {   
                Value = v.NumeroVivienda.ToString(),
                Text = $"Vivienda {v.NumeroVivienda} - {v.Cluster}"
            })
            .ToList();
        ViewBag.Viviendas = new SelectList(viviendaItems, "Value", "Text");

        var clusterItems = (viviendas ?? new List<Vivienda>())
            .GroupBy(v => new { v.IdCluster, v.Cluster })
            .Select(g => new SelectListItem
            {
                Value = g.Key.IdCluster.ToString(),
                Text = g.Key.Cluster ?? "Sin Cluster"
            })
            .Distinct()
            .ToList();
        ViewBag.Clusters = new SelectList(clusterItems, "Value", "Text");
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Error al cargar dropdowns");
        ViewBag.Lineas = new SelectList(new List<SelectListItem>());
        ViewBag.Viviendas = new SelectList(new List<SelectListItem>());
        ViewBag.Clusters = new SelectList(new List<SelectListItem>());
    }
}

}