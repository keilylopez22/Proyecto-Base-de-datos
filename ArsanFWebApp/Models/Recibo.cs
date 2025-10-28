namespace ArsanWebApp.Models;

public class Recibo
{
    public int IdRecibo { get; set; }
    public DateOnly? FechaEmision { get; set; }
    public int IdPago { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
    public string NombreCompleto { get; set; }
    public string NombreCluster { get; set; }
    public List<DetalleRecibo>? Detalles { get; set; } = new List<DetalleRecibo>();

    public decimal MontoTotal {get; set; }
}
