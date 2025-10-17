namespace ArsanWebApp.Models;

public class DetalleRecibo
{
    public int IdDetalleRecibo { get; set; }
    public int IdRecibo { get; set; }
    public int? IdCobroServicio { get; set; }
    public int? IdMultaVivienda { get; set; }
}