namespace ArsanWebApp.Models;

public class Empleado
{
    public int IdEmpleado { get; set; }
    public DateOnly? FechaAlta { get; set; }
    public DateOnly? FechaBaja { get; set; }
    public string? Estado { get; set; }
    public int IdPersona { get; set; }
    public int IdPuestoEmpleado { get; set; }
}