namespace ArsanWebApp.Models;

public class Vehiculo
{
    public int IdVehiculo { get; set; }
    public int? Año { get; set; }
    public string? Placa { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
    public int IdLinea { get; set; }
    public int IdMarca { get; set; } 
    public string? Linea { get; set; }
    public string? Marca { get; set; }
    public string? Vivienda { get; set; }
    public string? Cluster { get; set; }
}