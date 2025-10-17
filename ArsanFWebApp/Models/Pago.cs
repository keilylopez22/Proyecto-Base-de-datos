namespace ArsanWebApp.Models;

public class Pago
{
    public int IdPago { get; set; }
    public DateOnly? FechaPago { get; set; }
    public decimal? MontoTotal { get; set; }
    public int IdTipoPago { get; set; }
    public string? Referencia { get; set; }
}