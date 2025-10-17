namespace ArsanWebApp.Models;

public class VehiculoProhibido
{
    public int IdVehiculoProhibido { get; set; }
    public DateOnly? Fecha { get; set; }
    public string? Motivo { get; set; }
    public int IdVehiculo { get; set; }
}