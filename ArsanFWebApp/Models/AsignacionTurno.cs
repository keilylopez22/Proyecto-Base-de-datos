namespace ArsanWebApp.Models;

public class AsignacionTurno
{
    public int IdAsignacionTurno { get; set; }
    public int IdEmpleado { get; set; }
    public int IdTurno { get; set; }
    public DateOnly FechaAsignacion { get; set; }
}