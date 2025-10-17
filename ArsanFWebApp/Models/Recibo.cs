namespace ArsanWebApp.Models;

public class Recibo
{
    public int IdRecibo { get; set; }
    public DateOnly? FechaEmision { get; set; }
    public int IdPago { get; set; }
    public int NumeroVivienda { get; set; }
    public int IdCluster { get; set; }
}