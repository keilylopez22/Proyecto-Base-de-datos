namespace ArsanWebApp.Models;


public class Pago
{
    public int IdPago { get; set; }
    public DateOnly? FechaPago { get; set; }
    public decimal? MontoTotal { get; set; }
    public decimal? MontoLiquidado { get; set; }
    public decimal? Saldo { get; set; }
    // Nueva propiedad: lista de detalles
    public List<DetallePago> Detalles { get; set; } = new();
}

public class DetallePago
{
    
    public int IdPago { get; set; }
    public int IdDetallePago { get; set; }
    public decimal Monto { get; set; }
    public int IdTipoPago { get; set; }
    public string? Referencia { get; set; }

    // Propiedades para mostrar (opcional)
    public string? NombreTipoPago { get; set; }
}