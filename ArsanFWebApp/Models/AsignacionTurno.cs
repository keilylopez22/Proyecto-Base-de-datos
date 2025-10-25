namespace ArsanWebApp.Models;

public class AsignacionTurno
{
    public int IdAsignacionTurno { get; set; }
    public int IdEmpleado { get; set; }
    public int IdTurno { get; set; }
    public DateTime FechaAsignacion { get; set; }
    public string? TurnoDescripcion { get; set; }
    public string? NombreEmpleado { get; set; }

}