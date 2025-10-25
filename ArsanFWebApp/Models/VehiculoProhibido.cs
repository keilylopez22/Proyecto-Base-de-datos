namespace ArsanWebApp.Models;

public class VehiculoProhibido
{
    public int IdVehiculoProhibido { get; set; }
    public DateOnly? Fecha { get; set; }
    public string? Motivo { get; set; }
    public int IdVehiculo { get; set; }
    public string? Placa { get; set; }
    public string? Marca { get; set; }
}