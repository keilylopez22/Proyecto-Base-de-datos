namespace ArsanWebApp.Models;

public class MultaVivienda
{
    public int IdMultaVivienda { get; set; }
    public decimal? Monto { get; set; }
    public string? Observaciones { get; set; }
    public DateOnly? FechaInfraccion { get; set; }
    public DateOnly? FechaRegistro { get; set; }
    public string? EstadoPago { get; set; }
    public int IdTipoMulta { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
}