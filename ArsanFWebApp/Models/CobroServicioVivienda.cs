namespace ArsanWebApp.Models;

public class CobroServicioVivienda
{
    public int IdCobroServicio { get; set; }
    public DateOnly? FechaCobro { get; set; }
    public decimal? Monto { get; set; }
    public decimal? MontoAplicado { get; set; }
    public string? EstadoPago { get; set; }
    public int IdServicio { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
    public string? NombreServicio { get; set; }
    public string? NombreCluster { get; set; }
    
}