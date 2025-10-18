namespace ArsanWebApp.Models;

public class MiembroJuntaDirectiva
{
    public int IdMiembro { get; set; }
    public string? Estado { get; set; }
    public DateOnly FechaInicio { get; set; }
    public DateOnly FechaFin { get; set; }
    public int IdJuntaDirectiva { get; set; }
    public int IdPropietario { get; set; }
    public int IdPuesto { get; set; }

    
    public string? Cluster { get; set; }
    public string? Puesto { get; set; }
    public string? Propietario { get; set; }
}