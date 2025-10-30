namespace ArsanWebApp.Models;

public class RegistroAcceso
{
    public int IdAcceso { get; set; }
    public DateTime? FechaIngreso { get; set; }
    public DateTime? FechaSalida { get; set; }
    public string? Observaciones { get; set; }
    public int? IdVehiculo { get; set; }
    public int IdGarita { get; set; }
    public int? IdVisitante { get; set; }
    public int? IdResidente { get; set; }
    public int IdEmpleado { get; set; }

    public int? ViviendaDestino { get; set; }
    
    public string? TipoAcceso { get; set; }
    public string? DescripcionAcceso { get; set; }
    public int IdClusterGarita { get; set; }
    public string? ClusterGarita { get; set; }
    public string? VehiculoPlaca { get; set; }
    public string? VisitanteNombre { get; set; }
    public string? ResidenteNombre { get; set; }
    public string? EmpleadoNombre { get; set; }
}