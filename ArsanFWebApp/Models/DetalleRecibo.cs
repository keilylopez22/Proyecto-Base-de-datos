namespace ArsanWebApp.Models;

public class DetalleRecibo
{
    public int IdDetalleRecibo { get; set; }
    public int IdRecibo { get; set; }
    public int? IdCobroServicio { get; set; }
    public int? IdMultaVivienda { get; set; }
    public string? IdCluster { get; set; }
    public string? NombreMulta { get; set; }
    public string? NombrePropietario { get; set; }
    public string? NombreServicio { get; set; }
    public decimal? MontoServicio { get; set; }
    public int? NumeroVivienda { get; set; }
    public decimal? MontoAplicado { get; set; }
    public string? NombreCluster { get; set; }

}