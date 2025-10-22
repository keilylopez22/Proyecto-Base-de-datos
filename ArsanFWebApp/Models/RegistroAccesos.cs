namespace ArsanWebApp.Models;

public class RegistroAccesos
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
    public string? Placa { get; set; }
    public string? Visitante { get; set; }
    public string? Residente { get; set; }
    public string? Garita { get; set; }
    public string? Empleado { get; set; }
    public string? Cluster { get; set; }
}