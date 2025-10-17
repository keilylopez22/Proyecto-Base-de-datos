namespace ArsanWebApp.Models;

public class Vehiculo
{
    public int IdVehiculo { get; set; }
    public int? Año { get; set; }
    public string? Placa { get; set; } // UNIQUE
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
    public int IdLinea { get; set; }
    public int IdMarca { get; set; }
}